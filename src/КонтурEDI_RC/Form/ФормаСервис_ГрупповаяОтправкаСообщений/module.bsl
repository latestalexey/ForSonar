﻿Перем ЕстьСтатусы;
Перем InvoicИзРТУ;

Процедура КнопкаВыполнитьНажатие(Кнопка)

	Для Каждого Стр Из ТаблицаСообщений Цикл
		
		Если Стр.Флажок И НЕ Стр.УжеОтправлен Тогда
			
			Сообщение = ПодготовитьИсходящееСообщение(ТипСообщения, Стр.Документ);
			Параметры = Новый Структура();
			Параметры.Вставить("ОтправитьСообщениеИзФормы",	Истина);
			Параметры.Вставить("Сообщение",					Сообщение);
			
			ОтправитьСообщение(ТипСообщения,Стр.Документ,Параметры);
			
			Стр.Флажок = Ложь;
			Стр.УжеОтправлен = Истина;
			
		КонецЕсли;	
			
	КонецЦикла;
	
	Оповестить("КонтурEDI_ОбновитьЖурналСообщений", Новый Структура("ИмяФормы","ФормаСервис_ГрупповаяОтправкаСообщений"));
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ТаблицаСообщений.Колонки.Добавить("Сообщение");
	
	Для каждого Стр Из ТаблицаСообщений Цикл
		Стр.Флажок = Истина;
	КонецЦикла;
	
	ОбновитьСтатусы();
	
	Если ТипСообщения = "ORDRSP" Тогда
		
		ЭлементыФормы.ТаблицаСообщений.Колонки.ДатаПоставки.Видимость = Истина;
		
	Иначе
		
		ЭлементыФормы.ТаблицаСообщений.Колонки.ДатаПоставки.Видимость = Ложь;
		
	КонецЕсли;

	ПриОткрытииФормы(ЭтаФорма);

КонецПроцедуры

Процедура ТаблицаЗаказовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекСтрока = ЭлементыФормы.ТаблицаСообщений.ТекущиеДанные;
	
	Если НЕ ТекСтрока = Неопределено Тогда
		
		Если НЕ ТекСтрока.УжеОтправлен Тогда
		
			ФормаСообщения = ПолучитьФорму("ФормаСообщения");
			ФормаСообщения.Сообщение = ТекСтрока.Сообщение;
			ФормаСообщения.ОткрытьМодально();
			
			ОбновитьСтатусы(таблицасообщений.индекс(ТексТрока));
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаблицаЗаказовПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.УжеОтправлен = Истина Тогда
		
		ОформлениеСтроки.Ячейки.Статус.Гиперссылка	= Ложь;
		ОформлениеСтроки.Ячейки.Статус.ЦветТекста	= ОформлениеСтроки.Ячейки.Документ.ЦветТекста;
		
	ИначеЕсли НЕ ДанныеСтроки.Статус = "Исправить ошибки" Тогда	
		
		ОформлениеСтроки.Ячейки.Пометка.УстановитьФлажок(ДанныеСтроки.Флажок);
		
	КонецЕсли;
	
	Цвет = ЦветаСтиля.ЦветФонаПоля;
	
	Если ДанныеСтроки.Статус = "Подтвержден" Тогда
		Цвет = Новый Цвет(215,255,215);
	ИначеЕсли ДанныеСтроки.Статус = "Уточнен" Тогда
		Цвет = WebЦвета.СветлоЗолотистый;
	ИначеЕсли ДанныеСтроки.Статус = "Отклонен" Тогда
		Цвет = WebЦвета.СветлоРозовый;
	КонецЕсли;
	
	ОформлениеСтроки.Ячейки.Статус.ЦветФона = Цвет;
	
КонецПроцедуры

Процедура ИзменитьПримечание()
	
	ОтборСтрок = Новый Структура();
	ОтборСтрок.Вставить("Флажок",Истина);
	
	КопияТаблицы = ТаблицаСообщений.Скопировать(ОтборСтрок);
	
	Если КопияТаблицы.Количество() = 0 Тогда
		ТекстПодсказки = "Не отмечено ни одного документа";
	Иначе
		ИтоговаяСумма = КопияТаблицы.Итог("СуммаДокумента");
		ТекстПодсказки = "Будет отправлено сообщений: "+СокрЛП(КопияТаблицы.Количество())+" на сумму: "+Формат(ИтоговаяСумма,"ЧЦ=15; ЧДЦ=2");
	КонецЕсли;
	
	ЭлементыФормы.ПодсказкаСумма.Заголовок = ТекстПодсказки;
	
КонецПроцедуры

Процедура ТаблицаЗаказовПриИзмененииФлажка(Элемент, Колонка)
	
	ТекСтрока = Элемент.ТекущиеДанные;
	Если НЕ ТекСтрока = Неопределено Тогда
		
		ТекСтрока.Флажок = НЕ ТекСтрока.Флажок;
		
	КонецЕсли;
	
	ИзменитьПримечание();

КонецПроцедуры

Процедура КоманднаяПанельЗаказовУстановитьВсеФлажки(Кнопка)
	
	Для каждого Стр ИЗ ТаблицаСообщений Цикл
		
		Если НЕ Стр.УжеОтправлен И НЕ Стр.Статус = "Исправить ошибки" Тогда
			
			Стр.Флажок = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИзменитьПримечание();
	
КонецПроцедуры

Процедура КоманднаяПанельЗаказовСнятьВсеФлажки(Кнопка)
	
	ТаблицаСообщений.ЗаполнитьЗначения(Ложь,"Флажок");
	ИзменитьПримечание();
	
КонецПроцедуры

Процедура КоманднаяПанельЗаказовКнопкаОбновить(Кнопка)
	
	ОбновитьСтатусы();
	
КонецПроцедуры
процедура ОбновлениеСтатусаСтроки(Стр)
	Если ТипСообщения = "INVOIC" Тогда
		
		ДокОснование = Неопределено;
		
		Если InvoicИзРТУ Тогда
			ДокОснование = Стр.Документ;
		Иначе
				
			Если ИмяКонфигурации1С = "УТ_10_2" Тогда
				Стр.СуммаДокумента = Стр.Документ.Сумма;
				Если Стр.Документ.ДокументыОснования.Количество()>0 Тогда
					ДокОснование = Стр.Документ.ДокументыОснования[0].ДокументОснование;
				КонецЕсли;
			Иначе
				Стр.СуммаДокумента = Стр.Документ.СуммаДокумента;
				ДокОснование = Стр.Документ.ДокументОснование;
			КонецЕсли;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ДокОснование) Тогда
			
			АдресДоставкиДокумента = ДокОснование.АдресДоставки;
			Если ЗначениеЗаполнено(АдресДоставкиДокумента) Тогда
				Стр.АдресДоставки = АдресДоставкиДокумента;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Стр.СуммаДокумента = Стр.Документ.СуммаДокумента;
		Стр.АдресДоставки = Стр.Документ.АдресДоставки;
		
		АдресДоставкиДокумента = Стр.Документ.АдресДоставки;
		Если ЗначениеЗаполнено(АдресДоставкиДокумента) Тогда
			Стр.АдресДоставки = АдресДоставкиДокумента;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипСообщения = "DESADV" Тогда
		
		МожноОтправлять = МожноОтправлятьУведомлениеОбОтгрузке(Стр.Документ,Ложь);
		
		Если МожноОтправлять = Ложь Тогда
			
			Стр.Флажок = Ложь;
			Стр.УжеОтправлен = Истина;
			Стр.Сообщение = Неопределено;
			Стр.Статус = "Не отправлено подтверждение заказа!";
			
			ЕстьСтатусы = Истина;
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущийСтатус = ПолучитьСтатусСообщения(, Стр.Документ, ТипСообщения);
	
	Если НеПроверятьОтправкуСообщения = Ложь Тогда
		
		Если ЗначениеЗаполнено(ТекущийСтатус) И НЕ СокрЛП(ТекущийСтатус)="Ожидает исправления ошибок" Тогда
			
			Стр.Флажок = Ложь;
			Стр.УжеОтправлен = Истина;
			Стр.Сообщение = Неопределено;
			Стр.Статус = "Уже отправлено";
			
			ЕстьСтатусы = Истина;
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Стр.Сообщение = ПодготовитьИсходящееСообщение(ТипСообщения, Стр.Документ);
	
	Если Стр.Сообщение.СодержитОшибки = Истина Тогда
		Стр.Статус = "Исправить ошибки";
		Стр.Флажок = Ложь;
	Иначе
		Стр.Статус = Стр.Сообщение.Статус;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Стр.Статус) Тогда
		ЕстьСтатусы = Истина;
	КонецЕсли;
	
конецпроцедуры

Процедура ОбновитьСтатусы(строкаОбновления="")
	
	сч = 0;
	
	Всего = ТаблицаСообщений.Количество();
	
	ЕстьСтатусы = Ложь;
	
	
	если строкаОбновления="" тогда
		Для Каждого Стр Из ТаблицаСообщений Цикл
			
			сч=сч+1;
			
			Состояние("Подготавливается сообщение к отправке: "+СокрЛП(сч)+" из "+СокрЛП(Всего));
			ОбновлениеСтатусаСтроки(стр);
			
		КонецЦикла;
	иначе
		стр=ТаблицаСообщений[строкаОбновления];
		ОбновлениеСтатусаСтроки(стр);
	конецесли;
	ЭлементыФормы.ТаблицаСообщений.Колонки.Статус.Видимость = ЕстьСтатусы;
	
	ИзменитьПримечание();
	
КонецПроцедуры

Процедура ТаблицаСообщенийПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ТаблицаСообщенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ТаблицаСообщений.Количество()=0 Тогда
		Предупреждение("Нет сообщений, которые можно отправить!");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

InvoicИзРТУ = (ПолучитьКонстантуEDI("INVOIC_Из_РТУ") = Истина);
		