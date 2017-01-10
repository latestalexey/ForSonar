﻿
Процедура Надпись3Нажатие(Элемент)
//	ЗапуститьПриложение("https://edi.kontur.ru/1c/KonturEDI_82/КонтурEDI_1С_8_Интеграторам_ОбновлениеБазы.pdf");
	ЗапуститьПриложение("https://edi.kontur.ru/1c/konturEDI_82/КонтурEDI_1С_8_ОбновлениеБазы.pdf");
КонецПроцедуры

Процедура ВыбратьНажатие(Элемент)
	
	Если ЭлементыФормы.ПанельОписание.ТекущаяСтраница.Имя = "СвоиОбъекты" Тогда
		
		ПредложитьОбновитьОбъектыМетаданныхКонтурEDI("ОбновлениеДляХраненияДанных");
		
		Закрыть();
		
	ИначеЕсли ЭлементыФормы.ПанельОписание.ТекущаяСтраница.Имя = "ВнешнееХранилище_Файл" Тогда
		
		Если Не ЗапроситьПароль() Тогда //мера предосторожности
			Возврат;
		КонецЕсли;
		
		РазвернутьВнешнееХранилище_КонтурEDI();
		Если ВнешнееХранилище Тогда
			Предупреждение("Внешнее хранилище развернуто, перезагрузите модуль");
			РезультатВыполнения = "ок";
		Иначе
			Предупреждение("Не удалось развернуть внешнее хранилище");
		КонецЕсли;
		СоединениеСХранилищем = Неопределено;//обнулим
		Закрыть();
		
	ИначеЕсли ЭлементыФормы.ПанельОписание.ТекущаяСтраница.Имя = "ВнешнееХранилище_Сервер" Тогда

		ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		ДиалогВыбора.Заголовок		= "Укажите файл, в который нужно сохранить внешнюю базу";
		ДиалогВыбора.Фильтр			= "Конфигурация базы данных 1С (*.cf)|*.cf";
		ДиалогВыбора.ПолноеИмяФайла = "KonturEDI_storage.cf";
		
		Если ДиалогВыбора.Выбрать() Тогда      
			
			ПутьКФайлу = ДиалогВыбора.ПолноеИмяФайла;
			
		Иначе
			
			ЭтаФорма.Закрыть();
			Возврат;
			
		КонецЕсли;
		
		ПолучитьМакет("ОбновлениеДляХраненияДанных_ВнешнееХранилище").Записать(ПутьКФайлу);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	ПриОткрытииФормы(ЭтаФорма);
	Если ВнешнееХранилище Тогда
		//не будем показывать эту страницу, чтоб ВХ не затерли случайно
		ЭлементыФормы.ПанельОписание.Страницы.ВнешнееХранилище_Файл.Видимость = Ложь;
		ЭлементыФормы.ПанельОписание.Страницы.ВнешнееХранилище_Сервер.Видимость = Ложь;
	КонецЕсли;	
	
	_ПараметрыБазы = РазобратьСтрокуСоединенияИнформационнойБазы();
		
	Если _ПараметрыБазы.ТипСоединения = "Файл" Тогда
		ЭлементыФормы.ПанельОписание.Страницы.ВнешнееХранилище_Сервер.Видимость = Ложь;
	ИначеЕсли _ПараметрыБазы.ТипСоединения = "Сервер" Тогда
		ЭлементыФормы.ПанельОписание.Страницы.ВнешнееХранилище_Файл.Видимость = Ложь;
		ОбластьЗаменыТекста = ЭлементыФормы.ПолеТабличногоДокумента_ВнешнееХранилище_Сервер.Область("ИмяБазыИСервера");
		ОбластьЗаменыТекста.Текст = СтрЗаменить(ОбластьЗаменыТекста.Текст,"[ИмяБазы]",_ПараметрыБазы.ИмяБазы+"_KonturEDI_Data");
		ОбластьЗаменыТекста.Текст = СтрЗаменить(ОбластьЗаменыТекста.Текст,"[ИмяСервера]",_ПараметрыБазы.ИмяСервера);
	КонецЕсли;	
	
	ЭлементыФормы.ПолеТабличногоДокумента_ВнешнееХранилище_Сервер.ТолькоПросмотр = Истина;
	ЭлементыФормы.ПолеТабличногоДокумента_ВнешнееХранилище_Файл.ТолькоПросмотр = Истина;
	ЭлементыФормы.ПолеТабличногоДокумента_СвоиОбъекты.ТолькоПросмотр = Истина;
	
КонецПроцедуры

Функция ЗапроситьПароль()
	
	//Возврат Истина;//отладка!!!!
	
	Попытка//это может быть первый запуск модуля
		УчетныеЗаписи = ПолучитьСписокЭлементовСправочника("УчетныеЗаписи");
		
		ВыбраннаяУчетнаяЗапись=Неопределено;
		Для Каждого Учетка Из УчетныеЗаписи Цикл
			Если Учетка.Ссылка = ПолучитьКонстантуEDI("УчетнаяЗаписьПоУмолчанию")//возьмем именно основную УЗ
				Тогда
				ВыбраннаяУчетнаяЗапись=Учетка;
			КонецЕсли;
		КонецЦикла;	
		
		Если ВыбраннаяУчетнаяЗапись=Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;	
		
		Пароль="";
		Если Не ВвестиЗначение(Пароль,"Введите пароль учетной записи "+Учетка.Логин) Тогда
			Возврат Ложь;
		КонецЕсли;	
		
		Если Пароль<>ВыбраннаяУчетнаяЗапись.Пароль и Пароль<>"******" Тогда
			ВывестиПредупреждение_КонтурEDI("Неправильный пароль");
			Возврат Ложь;
		КонецЕсли;	
		
	Исключение	
	КонецПопытки;	
	
	Возврат Истина;
	
КонецФункции	

