﻿
Процедура ОткрытьФормуТекущейСтроки()
	
	ТекСтрока = ЭлементыФормы.ДеревоДокументов.ТекущаяСтрока;
	
	Если НЕ ТекСтрока = Неопределено Тогда
		Если ТекСтрока.Вид = "Документ" Тогда
			ТекСтрока.Ссылка.ПолучитьФорму().Открыть();
		Иначе
			Если СообщениеСсылка = ТекСтрока.Ссылка Тогда
				ЭтаФорма.Закрыть();
				Возврат;
			КонецЕсли;
			ОткрытьКарточкуСообщения(ТекСтрока.Ссылка,,ТекСтрока.ТипСообщения,ТекСтрока.Направление);
			ОбновитьДеревоДокументов();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельСообщенийОткрытьКарточкуСообщения(Кнопка)
	
	ОткрытьФормуТекущейСтроки();
	
КонецПроцедуры

Процедура ДеревоДокументовПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)

	Если ДанныеСтроки.Вид = "Сообщение" Тогда
		Если ДанныеСтроки.Направление = "Входящее" Тогда
			ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(ЭлементыФормы.КартинкаСообщениеВходящее.Картинка);
		Иначе
			ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(ЭлементыФормы.КартинкаСообщениеИсходящее.Картинка);
		КонецЕсли;
		Если ДанныеСтроки.Ссылка = СообщениеСсылка Тогда
			ОформлениеСтроки.Шрифт = Новый Шрифт(ОформлениеСтроки.Шрифт,,,Истина);			
		КонецЕсли;
	ИначеЕсли ДанныеСтроки.Вид = "ГруппаСообщений" Тогда
		ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(ЭлементыФормы.КартинкаСообщения.Картинка);
	ИначеЕсли ДанныеСтроки.Вид = "Документ" Тогда
		Если ДанныеСтроки.Проведен = Истина Тогда
			ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(ЭлементыФормы.КартинкаДокументПроведен.Картинка);
		ИначеЕсли ДанныеСтроки.ПометкаУдаления = Истина Тогда
			ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(ЭлементыФормы.КартинкаДокументУдален.Картинка);
		Иначе
			ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(ЭлементыФормы.КартинкаДокумент.Картинка);
		КонецЕсли;
		Если ДанныеСтроки.Ссылка = ДокументСсылка и не ЗначениеЗаполнено(СообщениеСсылка) Тогда
			ОформлениеСтроки.Шрифт = Новый Шрифт(ОформлениеСтроки.Шрифт,,,Истина);			
		КонецЕсли;
	КонецЕсли;	
		
КонецПроцедуры

Процедура ОбновитьДеревоДокументов()
	
	ДеревоДокументов = ПолучитьСвязанныеСообщения(,ДокументСсылка);
	
	Для каждого Стр Из ДеревоДокументов.Строки Цикл
		ЭлементыФормы.ДеревоДокументов.Развернуть(Стр,Истина);
	КонецЦикла;
	
	Если НастройкиМодуля.МыПоставщик Тогда
		Если ЗначениеЗаполнено(ДокументСсылка)
			И ТипЗнч(ДокументСсылка) = Тип(ПолучитьТипЗначенияОбъекта("ВходящийЗаказПокупателя"))
		Тогда
			//покажем вторую закладку и кнопку
			ЭлементыФормы.КоманднаяПанельСообщений.Кнопки.ОтвязатьДокумент.Доступность = Истина;
			ЭлементыФормы.Панель1.Страницы.СтраницаДокументыДляПривязки.Видимость = Истина;
			
			ДатаНач = ДокументСсылка.Дата;
			ДатаКон = ДокументСсылка.Дата;
			
			КоманднаяПанельПохожихДокументовОбновить("");
		КонецЕсли;
	КонецЕсли;	
		
КонецПроцедуры

Процедура ПриОткрытии()
	
	ПриОткрытииФормы(ЭтаФорма);
	
	ОбновитьДеревоДокументов();
	
КонецПроцедуры

Процедура ДеревоДокументовПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

Процедура ДеревоДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель)
	Отказ = Истина;
КонецПроцедуры

Процедура ДеревоДокументовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ОткрытьФормуТекущейСтроки();
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура КоманднаяПанельСообщенийОбновить(Кнопка)
	
	ОбновитьДеревоДокументов();
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Возврат;
	
	//Если ИмяСобытия = "КонтурEDI_УдаленоСообщение" Тогда
	//	ОбновитьДеревоДокументов();
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ДокументСсылка) Тогда
		ВывестиПредупреждение_КонтурEDI("Не удалось найти связанные сообщения!");
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры


Процедура КоманднаяПанельСообщенийПривязатьНакладную(Кнопка)
	
	ТекСтрока = ЭлементыФормы.ТаблицаПохожихДокументов.ТекущаяСтрока;
	
	Если ТекСтрока=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументДляПривязки = ТекСтрока.Ссылка;
	//создаем копию ORDERS.
	
	ДобавитьВиртуальныйORDERS(ДокументСсылка,ДокументДляПривязки);
	
    ОбновитьДеревоДокументов();//обновим таблицы
	
КонецПроцедуры

Процедура КоманднаяПанельСообщенийОтвязатьДокумент(Кнопка)
	
	ТекСтрока = ЭлементыФормы.ДеревоДокументов.ТекущаяСтрока;
	
	Если НЕ ТекСтрока = Неопределено Тогда
		Если ТекСтрока.Вид = "Документ"
			И ТипЗнч(ТекСтрока.Ссылка) = Тип(ПолучитьТипЗначенияОбъекта("ВходящийЗаказПокупателя"))	Тогда
			
			ОтвязываемыйДокумент = ТекСтрока.Ссылка;
			
			Если ОтвязываемыйДокумент=ДокументСсылка Тогда
				Предупреждение("Нельзя отвязывать текущий документ");
				Возврат;
			КонецЕсли;	
			
			Если Вопрос("Отвязать от данного заказа документ "+ОтвязываемыйДокумент+"?",РежимДиалогаВопрос.ОКОтмена)<>КодВозвратаДиалога.ОК Тогда
				Возврат;
 			КонецЕсли;
			
			ТабВиртуальныхСообщений = ПолучитьВиртуальныеСвязанныеORDERS(ОтвязываемыйДокумент);
			
			Если ТабВиртуальныхСообщений.Количество()=1 Тогда
				Предупреждение("Это единственный привязанный документ, его невозможно отвязать");
				Возврат;
			КонецЕсли;	
			
			УбратьВиртуальныйORDERS(ОтвязываемыйДокумент);
			
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьДеревоДокументов();
	
КонецПроцедуры

Процедура КоманднаяПанельПохожихДокументовОбновить(Кнопка)
	
	ТаблицаПохожихДокументов = ПолучитьТаблицуДокументовДляПривязки_к_ORDERS(ДокументСсылка,ДатаНач,ДатаКон);
	
КонецПроцедуры

Процедура ТаблицаПохожихДокументовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	ВыбраннаяСтрока.Ссылка.ПолучитьОбъект().ПолучитьФорму().Открыть();
КонецПроцедуры

Процедура КоманднаяПанельПохожихДокументовОткрыть(Кнопка)
	ТекСтрока = ЭлементыФормы.ТаблицаПохожихДокументов.ТекущаяСтрока;
	Если ТекСтрока<>Неопределено Тогда
		ТекСтрока.Ссылка.ПолучитьОбъект().ПолучитьФорму().Открыть();
	КонецЕсли;	
КонецПроцедуры

Процедура ПолеВводаДатаНачПриИзменении(Элемент)
	Если ДатаНач>ДатаКон Тогда 
		ДатаНач = ДатаКон;
	КонецЕсли;	
	
	КоманднаяПанельПохожихДокументовОбновить("");
КонецПроцедуры

Процедура ПолеВводаДатаКонПриИзменении(Элемент)
	Если ДатаКон<ДатаНач Тогда 
		ДатаКон = ДатаНач;
	КонецЕсли;	
	
	КоманднаяПанельПохожихДокументовОбновить("");
КонецПроцедуры
