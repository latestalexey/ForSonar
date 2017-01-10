﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	сч = 0;
	
	Для Каждого СтрокаОбработки Из СписокДокументов Цикл
		Если НЕ СтрокаОбработки.Переотправить Тогда Продолжить; КонецЕсли;
		сч=сч+1;
		
		Если ВнешнееХранилище Тогда
			НоваяЗаписьНабора = СоединениеСХранилищем.РегистрыСведений.КонтурEDI_ДополнительныеРеквизиты.СоздатьМенеджерЗаписи();
			НоваяЗаписьНабора.Объект=ЗначениеВСтрокуВнутр(СтрокаОбработки.Документ);
		Иначе	
			НоваяЗаписьНабора = РегистрыСведений.КонтурEDI_ДополнительныеРеквизиты.СоздатьМенеджерЗаписи();
			НоваяЗаписьНабора.Объект=СтрокаОбработки.Документ;
		КонецЕсли;	
		
		НоваяЗаписьНабора.Свойство="НужноОтправитьALCRPT";
		НоваяЗаписьНабора.Значение=Истина;
		Сообщить(СтрокаОбработки.Документ);
		НоваяЗаписьНабора.Записать();
	КонецЦикла;
	
	Если сч=0 Тогда
		ВывестиПредупреждение_КонтурEDI("Не выбрано ни одного документа для переотправки!");
	Иначе
	
		Состояние("Отправляются ALCRPT..");
		ОтправитьALCRPT();
		Сообщить("-------------------------------------------------------");
		Сообщить("ГОТОВО!");
		
		ЭтаФорма.Закрыть();
		
	КонецЕсли;
		
КонецПроцедуры

Процедура КоманднаяПанельКнопкаЗаполнить(Кнопка)
	
	Запрос = ИнициализироватьЗапрос_КонтурEDI(ВнешнееХранилище);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтурEDI_ДополнительныеРеквизиты.Объект КАК Документ,
	|	МИНИМУМ(КонтурEDI_Сообщения.ДатаДокумента) КАК ДатаДокумента
	|ПОМЕСТИТЬ ВТДокументы
	|ИЗ
	|	РегистрСведений.КонтурEDI_ДополнительныеРеквизиты КАК КонтурEDI_ДополнительныеРеквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтурEDI_Сообщения КАК КонтурEDI_Сообщения
	|		ПО КонтурEDI_ДополнительныеРеквизиты.Объект = КонтурEDI_Сообщения.Документ
	|			И (КонтурEDI_Сообщения.ТипСообщения = ""INVOIC""
	|				ИЛИ КонтурEDI_Сообщения.ТипСообщения = ""DESADV"")
	|			И (КонтурEDI_ДополнительныеРеквизиты.Свойство = ""ALCRPT_ID"")
	|ГДЕ
	|	КонтурEDI_ДополнительныеРеквизиты.Свойство = ""ALCRPT_ID""
	|	И КонтурEDI_Сообщения.ДатаДокумента МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтурEDI_ДополнительныеРеквизиты.Объект";
	Запрос.УстановитьПараметр("НачалоПериода",НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",КонецДня(КонецПериода));
	Запрос.Выполнить();
	
	Если ВнешнееХранилище Тогда
		Запрос.Текст = "Выбрать * Из ВТДокументы";
		Таб = Запрос.Выполнить().Выгрузить();
		Таб = ПолучитьТаблицуИзВнешнейБазы(Таб,Новый Структура("Документ",Новый ОписаниеТипов("ДокументСсылка.РеализацияТоваровУслуг")));
		Запрос = ИнициализироватьЗапрос_КонтурEDI(Ложь);
		Запрос.Текст =
		"Выбрать * поместить ВТДокументы из &Таб как _Таб";
		Запрос.УстановитьПараметр("Таб",Таб);
		Запрос.Выполнить();
	КонецЕсли;	
	
	Запрос.Текст = 
	"
	|ВЫБРАТЬ
	|	ВТДокументы.Документ,
	|	ВТДокументы.ДатаДокумента,
	|	ВТДокументы.Документ.Контрагент КАК Контрагент,
	|	ИСТИНА КАК Переотправить
	|ИЗ
	|	ВТДокументы КАК ВТДокументы";
	//"ВЫБРАТЬ
	//|	КонтурEDI_ДополнительныеРеквизиты.Объект КАК Документ,
	//|	ВЫРАЗИТЬ(КонтурEDI_ДополнительныеРеквизиты.Объект КАК Документ.РеализацияТоваровУслуг).Контрагент КАК Контрагент,
	//|	Истина КАК Переотправить
	//|ИЗ
	//|	РегистрСведений.КонтурEDI_ДополнительныеРеквизиты КАК КонтурEDI_ДополнительныеРеквизиты
	//|ГДЕ
	//|	КонтурEDI_ДополнительныеРеквизиты.Свойство = ""ALCRPT_ID""
	//|	И ВЫРАЗИТЬ(КонтурEDI_ДополнительныеРеквизиты.Объект КАК Документ.РеализацияТоваровУслуг).Дата МЕЖДУ &НачалоПериода И &КонецПериода";
	
	СписокДокументов.Очистить();
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	//Если ВнешнееХранилище Тогда
	//	//разбить запрос на 2
	//КонецЕсли;	
	
	
	Для каждого Стр Из ТЗ Цикл
		НоваяСтрока = СписокДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	НачалоПериода = ДобавитьМесяц(ТекущаяДата(),-1);
	КонецПериода = ТекущаяДата();
	
	ПриОткрытииФормы(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельКнопкаУстановитьФлажки(Кнопка)

	СписокДокументов.ЗаполнитьЗначения(Истина,"Переотправить");
	
КонецПроцедуры

Процедура КоманднаяПанельКнопкаСнятьФлажки(Кнопка)
	
	СписокДокументов.ЗаполнитьЗначения(Ложь,"Переотправить");
	
КонецПроцедуры

Процедура СписокДокументовПередНачаломДобавления(Элемент, Отказ, Копирование)

	Отказ = Истина;
	
КонецПроцедуры

Процедура СписокДокументовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры
