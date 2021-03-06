﻿Перем ПараметрыВывода;
Перем Параметры Экспорт;

Процедура ДобавитьОписаниеОшибки(ТаблицаОшибок, ТекстОшибки)
	
	НоваяСтрока = ТаблицаОшибок.Добавить();
	НоваяСтрока.ТекстОшибки = ТекстОшибки;	
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	//проверим входные параметры
	Успешно = Истина;
	ТаблицаОшибок = Новый ТаблицаЗначений;
	ТаблицаОшибок.Колонки.Добавить("ТекстОшибки");
		
	ВидРасхождения = Параметры.ВидРасхождения;
	
	Если ВидРасхождения = "РасхожденияЗаказа" Тогда
		Если Не ЗначениеЗаполнено(Параметры.Заказ) Тогда
			Успешно = Ложь;
			ДобавитьОписаниеОшибки(ТаблицаОшибок, "Отсутствует документ заказа в 1С.");
		КонецЕсли;
	ИначеЕсли ВидРасхождения = "РасхожденияПриемки" Тогда
		Если Не ЗначениеЗаполнено(Параметры.Накладная) Тогда
			Успешно = Ложь;
			ДобавитьОписаниеОшибки(ТаблицаОшибок, "Отсутствует документ накладной в 1С.");
		КонецЕсли;
	ИначеЕсли ВидРасхождения = "РасхожденияВерсийЗаказа" Тогда
		Если Не ЗначениеЗаполнено(Параметры.Заказ) Тогда
			Успешно = Ложь;
			ДобавитьОписаниеОшибки(ТаблицаОшибок, "Отсутствует Ссылка на сообщение в 1С.");
		КонецЕсли;
	КонецЕсли;
		
	Если Не Успешно Тогда
		Отказ = Истина;
		Сообщить("Невозможно выполнить анализ расхождений:");
		Для Каждого Строка Из ТаблицаОшибок Цикл
			Сообщить("   " + Строка.ТекстОшибки);		
		КонецЦикла;
		Возврат;
	КонецЕсли;

	//получим и проверим параметры вывода
	УстановитьПараметрыВывода();
	
    Если Не ПараметрыВывода.Успешно Тогда
		Отказ = Истина;
		Сообщить("Невозможно выполнить анализ расхождений: " + ПараметрыВывода.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПараметрыВывода()
	
	ПараметрыРасхождения = Новый Структура;
	Если Параметры.Свойство("Параметры") И ЗначениеЗаполнено(Параметры.Параметры) Тогда
		ПараметрыРасхождения = Параметры.Параметры;
	КонецЕсли;
	Если Параметры.Свойство("СравниваемыеПоля") Тогда
		ПараметрыРасхождения.Вставить("СравниваемыеПоля", Параметры.СравниваемыеПоля);
	КонецЕсли;
	
	ВидРасхождения = Параметры.ВидРасхождения;
		
	Если ВидРасхождения = "РасхожденияЗаказа" Тогда
		
		Заказ 					= Параметры.Заказ;
		ПараметрыВывода 		= ПолучитьДанныеРасхожденияЗаказаПокупателя(Заказ, ПараметрыРасхождения);
		
	ИначеЕсли ВидРасхождения = "РасхожденияПриемки" Тогда
		
		Накладная				= Параметры.Накладная;
		ПараметрыВывода 		= ПолучитьДанныеРасхожденияПриемки(Накладная, ПараметрыРасхождения);
		
	ИначеЕсли ВидРасхождения = "РасхожденияВерсийЗаказа" Тогда
		
		Заказ				= Параметры.Заказ;
		ПараметрыВывода 		= ПолучитьДанныеРасхожденияВерсийЗаказа(Заказ, ПараметрыРасхождения);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриОткрытии()
	
	ПриОткрытииФормы(ЭтаФорма);
		
	Макет = ПолучитьМакет("МакетСравненияТабличныхЧастей");
	Таблица = ЭлементыФормы.Таблица;
	Таблица.Очистить();
	ВывестиРасхождения(Таблица, Макет, ПараметрыВывода);
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	Отказ = Ложь;
	ПередОткрытием(Отказ, СтандартнаяОбработка);
	Если Отказ Тогда
		ЭтаФорма.Закрыть();
	КонецЕсли;
	
	ПриОткрытии();

КонецПроцедуры

	