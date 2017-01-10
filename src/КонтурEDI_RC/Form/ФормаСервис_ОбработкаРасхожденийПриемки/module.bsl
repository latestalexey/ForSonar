﻿Перем ТоварыСообщения;
Перем СверятьВRECADVЦеныИСтавки;
Перем ИспользуютсяХарактеристики;
Перем ИспользуютсяСерии;
Перем ОтправлятьВозвратнуюТаруВDESADV;
Перем СписокОшибок;
	

//{#Область Интерфейсные_Обработчики
	
// ИНТЕРФЕЙСНЫЕ ОБРАБОТЧИКИ

Процедура ПриОткрытии()
	
	Если ИсточникРасхождений = "ОбратныйЗаказ" Тогда
		
		ЭлементыФормы.НадписьДокумент.Заголовок = "Заказ:";
		ЭтаФорма.Заголовок = "Обработка уточнений по обратному заказу";
		
		ЭлементыФормы.Таб.Колонки.СуммаБезНДСВНакладной.Видимость = Ложь;
		ЭлементыФормы.Таб.Колонки.СуммаБезНДСПринято.Видимость = Ложь;
		ЭлементыФормы.Таб.Колонки.СуммаСНДСВНакладной.Видимость = Ложь;
		ЭлементыФормы.Таб.Колонки.СуммаСНДСПринято.Видимость = Ложь;
		
		ЭлементыФормы.Таб.Колонки.КоличествоВНакладной.ТекстШапки = "Количество в заказе";
		ЭлементыФормы.Таб.Колонки.КоличествоПринято.ТекстШапки = "Количество уточненное";
		
		ЭлементыФормы.Таб.Колонки.ЦенаБезНДСВНакладной.ТекстШапки = "Цена без НДС в заказе";
		ЭлементыФормы.Таб.Колонки.ЦенаСНДСВНакладной.ТекстШапки = "Цена с НДС в заказе";
		ЭлементыФормы.Таб.Колонки.ЦенаБезНДСПринято.ТекстШапки = "Цена без НДС уточненная";
		ЭлементыФормы.Таб.Колонки.ЦенаСНДСПринято.ТекстШапки = "Цена с НДС уточненная";
		
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить(ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОбработатьРезультатПриемки);
		
	Иначе//здесь всегда RECADV
		
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Удалить(ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ПеренестиВДокумент1С);
		
		//Если НЕ (ИмяКонфигурации1С="УПП" или ИмяКонфигурации1С="КА" или ИмяКонфигурации1С="УТ_10_3") Тогда
		//	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОбработатьРезультатПриемки.Кнопки.ОсновныеДействияФормыКорректировка.Доступность = ложь;
		//КонецЕсли;
		Если Метаданные.Документы.Найти("КорректировкаРеализации")=Неопределено Тогда
			//отключим для конфигураций, где нет такого документа
			ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОбработатьРезультатПриемки.Кнопки.СоздатьКорректировку.Доступность = Ложь;
		КонецЕсли;	
		
		
		//определим, надо ли будет переносить в реализацию цены, или обойдемся количеством
		_Сообщение = ПрочитатьСообщение(,Документ,"RECADV","Входящее");
		СверятьВRECADVЦеныИСтавки = (ПолучитьЗначениеСвойстваОбъектаEDI(_Сообщение.Отправитель1С, "СверятьВRECADVЦеныИСтавки") = Истина);
		ТекстПодсказки = "Перенести расхождения в накладную"+?(СверятьВRECADVЦеныИСтавки, " (будут перенесены количества и цены)"," (будут перенесены только количества)");
		_Кнопка = ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОбработатьРезультатПриемки.Кнопки.ОсновныеДействияФормыВыполнить;
		_Кнопка.Подсказка = ТекстПодсказки;
		_Кнопка.Пояснение = ТекстПодсказки;
		
		Если Не СверятьВRECADVЦеныИСтавки Тогда
			ИменаНевидимыхКолонок = EDI_РазложитьСтрокуВМассивСлов(
				"ЦенаБезНДСВНакладной,ЦенаСНДСВНакладной,СуммаБезНДСВНакладной,СуммаСНДСВНакладной,"+
				"ЦенаБезНДСПринято,ЦенаСНДСПринято,СуммаБезНДСПринято,СуммаСНДСПринято",
				",");
			Для Каждого ИмяКолонки Из ИменаНевидимыхКолонок Цикл
				ЭлементыФормы.Таб.Колонки[ИмяКолонки].Видимость = Ложь;
				ЭлементыФормы.Таб.Колонки[ИмяКолонки].Доступность = Ложь;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяКонфигурации1С = "БП" Тогда
		
		ЭлементыФормы.Таб.Колонки.ХарактеристикаНоменклатуры.Видимость = Ложь;
		ЭлементыФормы.Таб.Колонки.СерияНоменклатуры.Видимость = Ложь;
		
		КнопкаМеню = ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОбработатьРезультатПриемки;
		
		Если ПолучитьТипЗначенияОбъекта("ВходящийЗаказПокупателя",,Истина) = "схРеализацияСельхозПродукции" Тогда
			КнопкаМеню.Кнопки.СоздатьВозвратОтПокупателя.Доступность = Ложь;
		КонецЕсли;
		
		Если Найти(Метаданные.Синоним,"1.6")>0 Тогда
			КнопкаМеню.Кнопки.Удалить(КнопкаМеню.Кнопки.Разделитель);
			КнопкаМеню.Кнопки.Удалить(КнопкаМеню.Кнопки.СоздатьКорректировку);
		КонецЕсли;
	КонецЕсли;
	
	ПриОткрытииФормы(ЭтаФорма);
	
	Успешно = Истина;
	
	ЗаполнитьДеревоРасхожденийДокумента(Таб,Документ,ИсточникРасхождений,Успешно,ТоварыСообщения,СообщениеСсылка);
	
	Если Не Успешно Тогда
		//ЭтаФорма.Закрыть();
		Возврат;
	КонецЕсли;
	
	//Развернем строки дерева для удобства
	Для Каждого Стр Из Таб.Строки Цикл
		ЭлементыФормы.Таб.Развернуть(Стр);
	КонецЦикла;
	
	// Автотестирование
	
	Если ЗначениеЗаполнено(ПараметрыАвтотестирования) Тогда
		
		ПодключитьОбработчикОжидания("ЗапуститьАвтотесты",0.1,Истина);
		
	КонецЕсли;		

КонецПроцедуры

Процедура ЗапуститьАвтотесты()
	
	Для Каждого Действие ИЗ ПараметрыАвтотестирования.ВыполняемыеДействия Цикл
		
		Если Действие.Выполнено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СокрЛП(Действие.ФормаОбработки) = "ФормаОбработкиРасхождений" Тогда
			
			Выполнить(Действие.ВыполняемыйКод);
			
		Иначе
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ТабПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Цвет = Новый Цвет(215,255,215);
	
	ЦветЦенаБезНДС 	= Новый Цвет(255,255,255);
	ЦветЦенаСНДС 	= Новый Цвет(255,255,255);
	ЦветСуммаБезНДС = Новый Цвет(255,255,255);
	ЦветСуммаСНДС 	= Новый Цвет(255,255,255);
	
	Если НЕ ДанныеСтроки.КоличествоВНакладной = ДанныеСтроки.КоличествоПринято Тогда
		
		Если ДанныеСтроки.КоличествоПринято = 0 Тогда
			Цвет = WebЦвета.СветлоРозовый;
		Иначе
			Цвет = WebЦвета.СветлоЗолотистый;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ДанныеСтроки.ЦенаБезНДСВНакладной = ДанныеСтроки.ЦенаБезНДСПринято Тогда
		ЦветЦенаБезНДС = WebЦвета.СветлоЗолотистый;
	КонецЕсли;
	Если НЕ ДанныеСтроки.ЦенаСНДСВНакладной = ДанныеСтроки.ЦенаСНДСПринято Тогда
		ЦветЦенаСНДС = WebЦвета.СветлоЗолотистый;
	КонецЕсли;
	Если НЕ ДанныеСтроки.СуммаБезНДСВНакладной = ДанныеСтроки.СуммаБезНДСПринято Тогда
		ЦветСуммаБезНДС = WebЦвета.СветлоЗолотистый;
	КонецЕсли;
	Если НЕ ДанныеСтроки.СуммаСНДСВНакладной = ДанныеСтроки.СуммаСНДСПринято Тогда
		ЦветСуммаСНДС = WebЦвета.СветлоЗолотистый;
	КонецЕсли;
	
	Если ДанныеСтроки.ГруппаНоменклатур Тогда
		ОформлениеСтроки.ЦветФона = WebЦвета.ШелковыйОттенок;
		ОформлениеСтроки.Ячейки.КоличествоПринято.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.КоличествоПринято.Шрифт		= Новый Шрифт(ОформлениеСтроки.Ячейки.КоличествоПринято.Шрифт,,,Истина);
		ОформлениеСтроки.Ячейки.КоличествоВНакладной.Шрифт	= Новый Шрифт(ОформлениеСтроки.Ячейки.КоличествоВНакладной.Шрифт,,,Истина);
	Иначе
		ОформлениеСтроки.Ячейки.КоличествоПринято.ЦветФона = Цвет;
		
		ОформлениеСтроки.Ячейки.ЦенаБезНДСПринято.ЦветФона 	= ЦветЦенаБезНДС;
		ОформлениеСтроки.Ячейки.ЦенаСНДСПринято.ЦветФона	= ЦветЦенаСНДС;
		ОформлениеСтроки.Ячейки.СуммаБезНДСПринято.ЦветФона = ЦветСуммаБезНДС;
		ОформлениеСтроки.Ячейки.СуммаСНДСПринято.ЦветФона 	= ЦветСуммаСНДС;
		
		Если ЗначениеЗаполнено(ДанныеСтроки.Родитель) Тогда
			ОформлениеСтроки.Ячейки.КоличествоВНакладной.ЦветФона = WebЦвета.ШелковыйОттенок;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

Процедура ТабПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры

//}#КонецОбласти Интерфейсные_Обработчики

//{#Область Действия_Кнопок

//исправим документ "Реализация товаров и услуг"
Процедура ДействияФормыПеренестиВРеализацию(Кнопка)
	
	Если Не ЕстьВсеСоответствия() Тогда
		ВывестиПредупреждение_КонтурEDI("Невозможно выполнить выбранное действие: для некоторых строк не установлены соответствия товаров.");
		Возврат;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАвтотестирования) Тогда

		Если Вопрос("Вы выбрали действие: "+Кнопка.Текст+". Продолжить?",РежимДиалогаВопрос.ОКОтмена)<>КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;	

	КонецЕсли;
	
	НачатьТранзакцию_КонтурEDI();
	Попытка
		
		СтандартнаяОбработкаEDI = Истина;
		
		ТабСоответствий = РазложитьДеревоСоответствийВТаблицу(Таб);
		
		ОбработкаСобытияПодключаемогоМодуля("ОбработатьРасхожденияРезультатовПриемки",СтандартнаяОбработкаEDI,Новый Структура("Накладная,ТаблицаРасхождений",Документ,ТабСоответствий));
		
		Если СтандартнаяОбработкаEDI = Истина Тогда
			//Корректировка	
			Док = Документ.ПолучитьОбъект();
			
			ЗаполнитьТоварыДокумента_Реализация(Док,ТабСоответствий,
				?(Кнопка.имя="ОсновныеДействияФормыВыполнить","Реализация","КорректировкаРеализации")
				);
			
			Попытка
				Док.Записать(?(Док.Проведен,РежимЗаписиДокумента.Проведение,РежимЗаписиДокумента.Запись));
			Исключение
				//что-то пошло не так, и пользователя стоит об этом предупредить!
				_Ошибка = ОписаниеОшибки();
				
				ОтменитьТранзакцию_КонтурEDI();
				Сообщить_КонтурEDI("Не удалось обработать расхождения по причине:"+ОписаниеОшибки());
				Возврат;
			КонецПопытки;
				
			Если НЕ ЗначениеЗаполнено(ПараметрыАвтотестирования) Тогда
				
				Если ИмяКонфигурации1С = "БП" И ПолучитьТипЗначенияОбъекта("ВходящийЗаказПокупателя",,Истина) = "схРеализацияСельхозПродукции" Тогда
					Док.Ссылка.ПолучитьФорму().ОткрытьМодально();
				Иначе
					Форма = Док.ПолучитьФорму();
					Форма.ОткрытьМодально();
				КонецЕсли;
				
			КонецЕсли;
			
			//перенесли в документ
			УстановитьСтатусДокумента(Документ,"НакладнаяПринятЧастичноОбработан","Приемка",СообщениеСсылка);
			
			//проверим, был ли уже отправлен INVIOC
			СчетФактура = ПолучитьСчетФактуруНакладной(Документ);
			СообщениеINVOIC = НайтиСообщениеДокумента(СчетФактура,"INVOIC");
			Если СообщениеINVOIC<>Неопределено
				и (СообщениеINVOIC.Статус = "Подписан и отправлен") Тогда
				Если УстановитьСоединениеСДиадокомПоУмолчанию() Тогда
					boxId = СокрЛП(ПолучитьЗначениеСвойстваОбъектаEDI(СчетФактура, "boxId"));
					messageId = СокрЛП(ПолучитьЗначениеСвойстваОбъектаEDI(СчетФактура, "messageId"));
					invoiceId = СокрЛП(ПолучитьЗначениеСвойстваОбъектаEDI(СчетФактура, "invoiceId"));
					torg12Id = СокрЛП(ПолучитьЗначениеСвойстваОбъектаEDI(СчетФактура, "torg12Id"));
					Если ЗначениеЗаполнено(boxId) И ЗначениеЗаполнено(messageId) И (ЗначениеЗаполнено(invoiceId) или ЗначениеЗаполнено(torg12Id)) Тогда
						ОрганизацияПолучена = Ложь;
						Попытка
							ИДОрганизации = СтрЗаменить(boxId,"-","")+"@diadoc.ru";
							ОрганизацияДД = РаботаССерверомДиадок.Соединение.GetOrganizationById(ИДОрганизации);
							ОрганизацияПолучена = Истина;
	                    Исключение
						КонецПопытки;
						Если ОрганизацияПолучена Тогда
							ТОРГ12Получен = Ложь;
							Если ЗначениеЗаполнено(torg12Id) Тогда
								Попытка
									ДокументДД_ТОРГ12 = ОрганизацияДД.GetDocumentById(messageId+torg12Id);
									ТОРГ12Получен = Истина;
								Исключение
								КонецПопытки;
							КонецЕсли;
							ЭСФПолучен = Ложь;
							Если ЗначениеЗаполнено(invoiceId) Тогда
								Попытка
									ДокументДД_СФ = ОрганизацияДД.GetDocumentById(messageId+invoiceId);
									ЭСФПолучен = Истина;
								Исключение
								КонецПопытки;
							КонецЕсли;
							УстановитьСтатусИсправления = Ложь;
							Если ТОРГ12Получен И ДокументДД_ТОРГ12.Status = "OutboundRecipientSignatureRequestRejected" Тогда // отказано в подписании накладной
								УстановитьСтатусИсправления = Истина;
							КонецЕсли;
							Если ЭСФПолучен И ДокументДД_СФ.AmendmentRequested = Истина Тогда // если запрошено уточнение
								УстановитьСтатусИсправления = Истина;
							КонецЕсли;
							Если УстановитьСтатусИсправления Тогда	
								УстановитьСтатусСообщения(,  СчетФактура, "INVOIC", "ИсходящийОжидаетИсправленияОшибок");
								//на рефакторинг: а не надо ли нам переотправить INVOIC в любом случае?
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;				
			КонецЕсли;
			//Можно выполнить какие-то еще действия. Например, обработать возвратную тару, если выбрали действие "Создать корректировку реализации".
			//Документ - сама Реализация. 
			ОбработкаСобытияПодключаемогоМодуля("ПослеОбработкиРасхожденияРезультатовПриемки",СтандартнаяОбработкаEDI,Новый Структура("Накладная,ВыбранноеДействие,ТаблицаРасхождений",Документ,"Реализация",ТабСоответствий));
				
		КонецЕсли; //СтандартнаяОбработкаEDI = Истина 
		ЗафиксироватьТранзакцию_КонтурEDI();
	Исключение
		ОтменитьТранзакцию_КонтурEDI();
		Сообщить_КонтурEDI("Не удалось обработать расхождения по причине:"+ОписаниеОшибки());
	КонецПопытки;
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

//перенесем расхождения в документ "Возврат товаров от покупателя"
Процедура ДействияФормыСоздатьВозвратОтПокупателя(Кнопка)
	
	Если Не ЕстьВсеСоответствия() Тогда
		ВывестиПредупреждение_КонтурEDI("Невозможно выполнить выбранное действие: для некоторых строк не установлены соответствия товаров.");
		Возврат;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАвтотестирования) Тогда
	
		Если Вопрос("Вы выбрали действие: "+Кнопка.Текст+". Продолжить?",РежимДиалогаВопрос.ОКОтмена)<>КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;	
		
	КонецЕсли;
			
	ДобавлятьВозвратВОснованияСчетФактуры = (ПолучитьКонстантуEDI("ДобавлятьВозвратВОснованияСчетФактуры")=Истина);
	
	Если ДобавлятьВозвратВОснованияСчетФактуры Тогда
		//для начала найдем счет-фактуру по данной накладной. В нее потом допишем наш возврат в "документы-основания"
		СчетФактура=Неопределено;
		Если ИмяКонфигурации1С = "УТ_10_2" Тогда
			//здесь не используем подстановку в СФ
		Иначе
			Запрос=Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	СчетФактураВыданныйДокументыОснования.Ссылка
			|ИЗ
			|	Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
			|ГДЕ
			|	СчетФактураВыданныйДокументыОснования.ДокументОснование = &ДокументОснование
			|	И НЕ СчетФактураВыданныйДокументыОснования.Ссылка.ПометкаУдаления"
			);
			Запрос.УстановитьПараметр("ДокументОснование",Документ);
			Выб=Запрос.Выполнить().Выбрать();
			Если Выб.Следующий() Тогда
				СчетФактура=Выб.Ссылка;
			КонецЕсли;	
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СчетФактура) Тогда
			ВывестиПредупреждение_КонтурEDI("Не найдена счет-фактура по данной накладной. Для создания возврата сначала создайте счет-фактуру.");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	СтандартнаяОбработкаEDI = Истина;
	
	ТабСоответствий = РазложитьДеревоСоответствийВТаблицу(Таб);
	
	ОбработкаСобытияПодключаемогоМодуля("ОбработатьРасхожденияРезультатовПриемки",СтандартнаяОбработкаEDI,Новый Структура("Накладная,ТаблицаРасхождений",Документ,ТабСоответствий));
	
	Если СтандартнаяОбработкаEDI = Истина Тогда
		
		ДокументВозврата=Документы[ПолучитьТипЗначенияОбъекта("ВходящийВозврат",,Истина)].СоздатьДокумент();
		ДокументВозврата.Заполнить(Документ);
		
		Если ИмяКонфигурации1С = "ДалионУМ" Тогда
			ДокументВозврата.УчитыватьНДС 		= Документ.УчитыватьНДС;
			ДокументВозврата.СуммаВключаетНДС 	= Документ.СуммаВключаетНДС;
		КонецЕсли;
		
		ЗаполнитьТоварыДокумента_Возврат(ДокументВозврата,ТабСоответствий,
			"Возврат"
			);
		
	КонецЕсли;
	//обработать таблицу расхождений
	
	Если СписокОшибок="" Тогда
		
		Если НЕ ЗначениеЗаполнено(ПараметрыАвтотестирования) Тогда
			ДокументВозврата.ПолучитьФорму().ОткрытьМодально();
		Иначе
			ДокументВозврата.Дата = ТекущаяДата();
			ДокументВозврата.Записать();
		КонецЕсли;
		
		//посмотрим, записал ли пользователь документ в модальном окне.
		Если ДокументВозврата.ЭтоНовый() Тогда
			//ничего не делаем, оставляем приемку не обработанную
		Иначе
			
			Если ДобавлятьВозвратВОснованияСчетФактуры Тогда
				//еще добавим возврат в основания счета-фактуры
				ДокСФ=СчетФактура.ПолучитьОбъект();
				НовСтрока=ДокСФ.ДокументыОснования.Добавить();
				НовСтрока.ДокументОснование=ДокументВозврата.Ссылка;
				ДокСФ.Записать();//она не проводится толком
			КонецЕсли;
			
			УстановитьСтатусДокумента(Документ,"НакладнаяПринятЧастичноОбработан","Приемка",СообщениеСсылка);
			//Можно выполнить какие-то еще действия. Например, обработать возвратную тару.
			//Документ - сама Реализация. 
			ОбработкаСобытияПодключаемогоМодуля("ПослеОбработкиРасхожденияРезультатовПриемки",СтандартнаяОбработкаEDI,Новый Структура("Накладная,ВыбранноеДействие,ТаблицаРасхождений",ДокументВозврата.Ссылка,"Возврат",ТабСоответствий));
			ЭтаФорма.Закрыть();
		КонецЕсли;	
		
	Иначе
		Сообщить("Не удалось создать документ возврата от покупателя");
		Сообщить(СписокОшибок);
		Предупреждение("Не удалось создать документ возврата от покупателя");
		ДокументВозврата=Неопределено; //отпустим документ
	КонецЕсли;	

КонецПроцедуры

//не будем ничего переносить в документ, но пометим его как обработанный
Процедура ОсновныеДействияФормыИгнорироватьРасхождения(Кнопка)
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАвтотестирования) Тогда

		Если Вопрос("Вы выбрали действие: "+Кнопка.Текст+". Продолжить?",РежимДиалогаВопрос.ОКОтмена)<>КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;	
		
	КонецЕсли;
			
	УстановитьСтатусДокумента(Документ,"НакладнаяПринятЧастичноОбработан","Приемка",СообщениеСсылка);
	
	ОбработкаСобытияПодключаемогоМодуля("ПослеОбработкиРасхожденияРезультатовПриемки",,Новый Структура("Накладная,ВыбранноеДействие,ТаблицаРасхождений,СообщениеСсылка",Документ,"Игнорировать",Неопределено,СообщениеСсылка));

	Закрыть();
	
КонецПроцедуры

//для обратного заказа
Процедура ОсновныеДействияФормыПеренестиВДокумент1С(Кнопка)
	
	Если Не ЕстьВсеСоответствия() Тогда
		ВывестиПредупреждение_КонтурEDI("Невозможно выполнить выбранное действие: для некоторых строк не установлены соответствия товаров.");
		Возврат;
	КонецЕсли;	
	
	ТабСоответствий = РазложитьДеревоСоответствийВТаблицу(Таб);
	
	Док = Документ.ПолучитьОбъект();
	
	СуммаВключаетНДС = ПолучитьРеквизитДокументаДляСообщения(Док,"СуммаВключаетНДС");
	
	//Новый товар 
	Для Каждого стр Из ТабСоответствий Цикл
		
		НайденнаяСтрока = Неопределено;
		НайденнаяСтрока = НайтиСоответствиеСтрокиВДокументе(Стр,Док);
		//ПриоритетПоиска = 0;
		//Для Каждого СтрРасхождений Из Док.Товары Цикл
		//	Если Стр.Номенклатура = СтрРасхождений.Номенклатура Тогда
		//		ТекПриоритет = 1;
		//		Если ИспользуютсяХарактеристики И ЗначениеЗаполнено(Стр.ХарактеристикаНоменклатуры) Тогда
		//			Если СтрРасхождений.ХарактеристикаНоменклатуры = Стр.ХарактеристикаНоменклатуры Тогда
		//				ТекПриоритет = ТекПриоритет+1;
		//			КонецЕсли;
		//		ИначеЕсли ИмяКонфигурации1С = "БП" Тогда
		//			ТекПриоритет = ТекПриоритет+1;	
		//		ИначеЕсли НЕ ЗначениеЗаполнено(СтрРасхождений.ХарактеристикаНоменклатуры) Тогда
		//			ТекПриоритет = ТекПриоритет+1;
		//		КонецЕсли;
		//		Если ИспользуютсяСерии И ЗначениеЗаполнено(Стр.СерияНоменклатуры) Тогда
		//			Если СтрРасхождений.СерияНоменклатуры = Стр.СерияНоменклатуры Тогда
		//				ТекПриоритет = ТекПриоритет+1;
		//			КонецЕсли;
		//		КонецЕсли;
		//		
		//		Если ТекПриоритет>ПриоритетПоиска Тогда
		//			НайденнаяСтрока = СтрРасхождений;
		//			ПриоритетПоиска = ТекПриоритет;
		//		КонецЕсли;
		//	КонецЕсли;
		//	
		//КонецЦикла;
		
		Если НайденнаяСтрока <> Неопределено Тогда
			//Если переносим расхождения в исходный документ, то строки с нулевым принятым количеством удаляем из документа.
			Если (стр.КоличествоПринято = 0) Тогда
				
				ИмяТабличнойЧасти = Метаданные.НайтиПоТипу(ТипЗнч(НайденнаяСтрока)).Имя;
				Док[ИмяТабличнойЧасти].Удалить(НайденнаяСтрока);
				
			Иначе
				ТребуетсяПересчетПоТабличнойЧасти = Ложь;
				
				Если НЕ стр.КоличествоПринято = НайденнаяСтрока.Количество Тогда
					НайденнаяСтрока.Количество = Стр.КоличествоПринято;
					Если ИмяКонфигурации1С = "ТКПТ" Тогда
						НайденнаяСтрока.КоличествоБазовое = НайденнаяСтрока.Количество;
					КонецЕсли;
					ТребуетсяПересчетПоТабличнойЧасти = Истина;
				КонецЕсли;
				
				//проверяем на нулевые значения цену и сумму Из RECADV, которыми при несовпедении с ценами по РТУ хотим перезаполнять текущую позицию
				//будем полагать, что Если цена или сумма нулевая, то ее не отправила сеть, следовательно не будем перезаполнять цену и сумму по текущей позиции
				Если СуммаВключаетНДС Тогда
					Если (Не Стр.ЦенаСНДСПринято = 0) и (Не Стр.СуммаСНДСПринято = 0) Тогда						
						Если НЕ Стр.ЦенаСНДСПринято = НайденнаяСтрока.Цена Тогда
							НайденнаяСтрока.Цена = Стр.ЦенаСНДСПринято;
							ТребуетсяПересчетПоТабличнойЧасти = Истина;
						КонецЕсли;
						Если НЕ Стр.СуммаСНДСПринято = НайденнаяСтрока.Сумма Тогда
							НайденнаяСтрока.Сумма = Стр.СуммаСНДСПринято;
							ТребуетсяПересчетПоТабличнойЧасти = Истина;
						КонецЕсли;
					КонецЕсли;
				Иначе
					Если (Не Стр.ЦенаБезНДСПринято = 0) и (Не Стр.СуммаБезНДСПринято = 0) Тогда
						Если НЕ Стр.ЦенаБезНДСПринято = НайденнаяСтрока.Цена Тогда
							НайденнаяСтрока.Цена = Стр.ЦенаБезНДСПринято;
							ТребуетсяПересчетПоТабличнойЧасти = Истина;
						КонецЕсли;
						Если НЕ Стр.СуммаБезНДСПринято = НайденнаяСтрока.Сумма Тогда
							НайденнаяСтрока.Сумма = Стр.СуммаБезНДСПринято;
							ТребуетсяПересчетПоТабличнойЧасти = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
				Если ТребуетсяПересчетПоТабличнойЧасти Тогда	
					
					ПересчитатьСтрокуДокумента(НайденнаяСтрока,Док);
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли Стр.КоличествоПринято<>0 Тогда
			
			НоваяСтрока = Док.Товары.Добавить();
			СтрокаСообщения=ТоварыСообщения.Получить(ТабСоответствий.Индекс(стр));
			НоваяСтрока.Номенклатура		= Стр.Номенклатура;
			НоваяСтрока.ЕдиницаИзмерения	= СтрокаСообщения.ЕдиницаИзмерения;
			
			Если НЕ ИмяКонфигурации1С = "БП" Тогда
				НоваяСтрока.Коэффициент			= СтрокаСообщения.ЕдиницаИзмерения.Коэффициент;
				НоваяСтрока.ХарактеристикаНоменклатуры	= Стр.ХарактеристикаНоменклатуры;
			КонецЕсли;
			
			НоваяСтрока.Количество			= Стр.КоличествоПринято;
			Если ИмяКонфигурации1С = "ТКПТ" Тогда
				НоваяСтрока.КоличествоБазовое = НоваяСтрока.Количество;
			КонецЕсли;
			
			Если СуммаВключаетНДС Тогда
				НоваяСтрока.Цена				= ?( (Не Стр.ЦенаСНДСПринято = 0 и Не Стр.СуммаСНДСПринято = 0), Стр.ЦенаСНДСПринято, СтрокаСообщения.ЦенаСНДСПринято );
				НоваяСтрока.Сумма				= ?( (Не Стр.ЦенаСНДСПринято = 0 и Не Стр.СуммаСНДСПринято = 0), Стр.СуммаСНДСПринято, СтрокаСообщения.СуммаСНДСПринято );
			Иначе
				НоваяСтрока.Цена				= ?( (Не Стр.ЦенаБезНДСПринято = 0 и Не Стр.СуммаБезНДСПринято = 0), Стр.ЦенаБезНДСПринято, СтрокаСообщения.ЦенаБезНДСПринято );
				НоваяСтрока.Сумма				= ?( (Не Стр.ЦенаБезНДСПринято = 0 и Не Стр.СуммаБезНДСПринято = 0), Стр.СуммаБезНДСПринято, СтрокаСообщения.СуммаБезНДСПринято );
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Док.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Док.Записать();
	КонецПопытки;
	
	УстановитьСтатусДокумента(Документ,"НетРасхождений","ОбратныйЗаказ",СообщениеСсылка);
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

//создадим документ "Корректировка реализации" и отправим его напрямую в Диадок как КСФ
Процедура ДействияФормыСоздатьКСФ(Кнопка)
	
	Если Не ЕстьВсеСоответствия() Тогда
		ВывестиПредупреждение_КонтурEDI("Невозможно выполнить выбранное действие: для некоторых строк не установлены соответствия товаров.");
		Возврат;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАвтотестирования) Тогда
	
		Если Вопрос("Вы выбрали действие: "+Кнопка.Текст+". Продолжить?",РежимДиалогаВопрос.ОКОтмена)<>КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;	
		
	КонецЕсли;
			
	СтандартнаяОбработкаEDI = Истина;
	
	ТабСоответствий = РазложитьДеревоСоответствийВТаблицу(Таб);
	
	ОбработкаСобытияПодключаемогоМодуля("ОбработатьРасхожденияРезультатовПриемки",СтандартнаяОбработкаEDI,Новый Структура("Накладная,ТаблицаРасхождений",Документ,ТабСоответствий));
	
	Если СтандартнаяОбработкаEDI = Истина Тогда
		
		Нак = Документ.ПолучитьОбъект();
		
		//добавить проверку на то, что корректировка реализации уже создана, Если да, то спрашиваем у пользователя брать ее за основу или создавать новую
		
		Док = Документы.КорректировкаРеализации.СоздатьДокумент();// СчетФактураВыданный
		Док.Заполнить(Нак.Ссылка);
		док.ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.СогласованноеИзменение;
		
		ЗаполнитьТоварыДокумента_КорректировкаРеализации(Док,ТабСоответствий,
			?(Кнопка.имя="ОсновныеДействияФормыВыполнить","Реализация","КорректировкаРеализации")
			);
		
		Если ИмяКонфигурации1С = "БП" И ПолучитьТипЗначенияОбъекта("ВходящийЗаказПокупателя",,Истина) = "схРеализацияСельхозПродукции" Тогда
			Док.Ссылка.ПолучитьФорму().ОткрытьМодально();
		Иначе
			Форма = Док.ПолучитьФорму();
			Форма.ОткрытьМодально();
		КонецЕсли;
		
		Если НЕ Док.ЭтоНовый() Тогда
			//
			УстановитьСтатусДокумента(Документ,"НакладнаяПринятЧастичноОбработан","Приемка",СообщениеСсылка);
			//Можно выполнить какие-то еще действия. Например, обработать возвратную тару, если выбрали действие "Создать корректировку реализации".
			//Документ - сама Реализация. 
			ОбработкаСобытияПодключаемогоМодуля("ПослеОбработкиРасхожденияРезультатовПриемки",СтандартнаяОбработкаEDI,Новый Структура("Накладная,ВыбранноеДействие,ТаблицаРасхождений",Документ,"КорректировкаРеализации",ТабСоответствий));
			
			ЭтаФорма.Закрыть();
			
		КонецЕсли;	
		
	КонецЕсли; //СтандартнаяОбработкаEDI = Истина 
	
	
КонецПроцедуры

//}#КонецОбласти Действия_Кнопок

//{#Область Сервисные_Функции

// СЕРВИСНЫЕ ФУНКЦИИ


Функция ЕстьВсеСоответствия()
	//если у нас нет хотя бы одного соответствия товаров, то мы не сможем корректно заполнить реализацию, возврат или КСФ
	ФлагОтмены = Ложь;
	Для Каждого Стр1 Из Таб.Строки Цикл
		Если Стр1.ГруппаНоменклатур Тогда
		Для Каждого Стр2 Из Стр1.Строки Цикл
			Если ТипЗнч(Стр2.Номенклатура)<>Тип("СправочникСсылка.Номенклатура") 
				Или Не ЗначениеЗаполнено(Стр2.Номенклатура) Тогда
				ФлагОтмены = Истина;
				Сообщить("Не назначено соответствие для наименования сети: "+Стр2.Номенклатура);
			КонецЕсли;	
		КонецЦикла;	
		
		ИначеЕсли ТипЗнч(Стр1.Номенклатура)<>Тип("СправочникСсылка.Номенклатура") 
			Или Не ЗначениеЗаполнено(Стр1.Номенклатура) Тогда
			ФлагОтмены = Истина;
			Сообщить("Не назначено соответствие для наименования сети: "+Стр1.Номенклатура);
		КонецЕсли;	
	КонецЦикла;	
	Возврат Не ФлагОтмены;
КонецФункции	

Процедура ЗаполнитьТоварыДокумента_Реализация(Док,ТабСоответствий,ВариантЗаполнения)
	
	СуммаВключаетНДС = ПолучитьРеквизитДокументаДляСообщения(Док,"СуммаВключаетНДС");
	
	МассивНеобработанныхСтрокКорректировки = Новый Массив;
	
	//пройдемся по строкам
	Для Каждого СтрокаСоответствий Из ТабСоответствий Цикл
		
		//поищем строку с таким товаром в документе
		НайденнаяСтрока = НайтиСоответствиеСтрокиВДокументе(СтрокаСоответствий,Док);
		
		//нашли или не нашли строку в документе. Обработаем это
			Если ОтправлятьВозвратнуюТаруВDESADV=истина И НайденнаяСтрока=Неопределено Тогда
				//поищем в возвратной таре
				//она присутствует во всех типовых конфигурациях, но в ней нет ни серий, ни характеристик, ни НДС
				
				ПриоритетПоиска = 0;
				Для Каждого СтрРасхождений Из Док.ВозвратнаяТара Цикл
					Если СтрокаСоответствий.Номенклатура = СтрРасхождений.Номенклатура Тогда
						ТекПриоритет = 1;
						
						Если ТекПриоритет>ПриоритетПоиска Тогда
							НайденнаяСтрока = СтрРасхождений;
							ПриоритетПоиска = ТекПриоритет;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если НайденнаяСтрока <> Неопределено Тогда
				//Если переносим расхождения в исходный документ, то строки с нулевым принятым количеством удаляем Из документа.
				Если (СтрокаСоответствий.КоличествоПринято = 0) Тогда
					ИмяТабличнойЧасти = Метаданные.НайтиПоТипу(ТипЗнч(НайденнаяСтрока)).Имя;
					Док[ИмяТабличнойЧасти].Удалить(НайденнаяСтрока);
				Иначе //КоличествоПринято<>0, нам надо изменить Количество в строке документа, а также при необходимости перезаполнить/пересчитать цены
					ТребуетсяПересчетПоТабличнойЧасти = Ложь;
					
					Если СтрокаСоответствий.КоличествоПринято <> НайденнаяСтрока.Количество Тогда
						НайденнаяСтрока.Количество = СтрокаСоответствий.КоличествоПринято;
						Если ИмяКонфигурации1С = "ТКПТ" Тогда
							НайденнаяСтрока.КоличествоБазовое = НайденнаяСтрока.Количество; 		     		
						КонецЕсли;
						ТребуетсяПересчетПоТабличнойЧасти = Истина;
					КонецЕсли;
					
					Если СверятьВRECADVЦеныИСтавки Тогда
						
						//проверяем на нулевые значения цену и сумму Из RECADV, которыми при несовпадении с ценами по РТУ хотим перезаполнять текущую позицию
						//будем полагать, что Если цена или сумма нулевая, то ее не отправила сеть, следовательно не будем перезаполнять цену и сумму по текущей позиции
						
						_Цена = ?(СуммаВключаетНДС,СтрокаСоответствий.ЦенаСНДСПринято,СтрокаСоответствий.ЦенаБезНДСПринято);
						_Сумма = ?(СуммаВключаетНДС,СтрокаСоответствий.СуммаСНДСПринято,СтрокаСоответствий.СуммаБезНДСПринято);
						
						Если _Цена <> НайденнаяСтрока.Цена и _Цена <> 0 Тогда
							НайденнаяСтрока.Цена = _Цена;
							ТребуетсяПересчетПоТабличнойЧасти = Истина;
						КонецЕсли;
						
					КонецЕсли;	
					
					Если ТребуетсяПересчетПоТабличнойЧасти Тогда	
						ПересчитатьСтрокуДокумента(НайденнаяСтрока,Док);
					КонецЕсли;
					
				КонецЕсли;
				
			ИначеЕсли СтрокаСоответствий.КоличествоПринято<>0 Тогда
				//Не нашли такую строку в документе Реализация, придется ее добавить
				
				НоваяСтрока = Док.Товары.Добавить();
				НоваяСтрока.Номенклатура		= СтрокаСоответствий.Номенклатура;
				НоваяСтрока.ЕдиницаИзмерения	= СтрокаСоответствий.ЕдиницаИзмерения;
				
				Если ИмяКонфигурации1С <> "БП" Тогда
					НоваяСтрока.Коэффициент			= СтрокаСоответствий.ЕдиницаИзмерения.Коэффициент;
					НоваяСтрока.ХарактеристикаНоменклатуры	= СтрокаСоответствий.ХарактеристикаНоменклатуры;
				КонецЕсли;
				
				НоваяСтрока.Количество			= СтрокаСоответствий.КоличествоПринято;
				
				НоваяСтрока.Цена	= ?(СуммаВключаетНДС, СтрокаСоответствий.ЦенаСНДСПринято, СтрокаСоответствий.ЦенаБезНДСПринято );
				НоваяСтрока.Сумма	= ?(СуммаВключаетНДС, СтрокаСоответствий.СуммаСНДСПринято, СтрокаСоответствий.СуммаБезНДСПринято );  //а сумма НДС???
				
			КонецЕсли;
	КонецЦикла;//по строкам
	
КонецПроцедуры	

Процедура ЗаполнитьТоварыДокумента_Возврат(Док,ТабСоответствий,ВариантЗаполнения)
	
	СуммаВключаетНДС = ПолучитьРеквизитДокументаДляСообщения(Док,"СуммаВключаетНДС");
	
	МассивНеобработанныхСтрокКорректировки = Новый Массив;
	
	//пройдемся по строкам
	Для Каждого СтрокаСоответствий Из ТабСоответствий Цикл
		
		//поищем строку с таким товаром в документе
		НайденнаяСтрока = НайтиСоответствиеСтрокиВДокументе(СтрокаСоответствий,Док);
		
		//нашли или не нашли строку в документе. Обработаем это
		
		Если ОтправлятьВозвратнуюТаруВDESADV И НайденнаяСтрока=Неопределено Тогда
			//поищем в возвратной таре
			//она присутствует во всех типовых конфигурациях, но в ней нет ни серий, ни характеристик, ни НДС
			
			ПриоритетПоиска = 0;
			
			Для Каждого СтрРасхождений Из Док.ВозвратнаяТара Цикл
				Если СтрокаСоответствий.Номенклатура = СтрРасхождений.Номенклатура Тогда
					ТекПриоритет = 1;
					
					Если ТекПриоритет>ПриоритетПоиска Тогда
						НайденнаяСтрока = СтрРасхождений;
						ПриоритетПоиска = ТекПриоритет;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если НайденнаяСтрока <> Неопределено Тогда
			//нашли такую строку в документе "Возврат товаров", дальше решим, что с ней делать
			//На рефакторинг: похоже здесь у нас жесткое допущение, что такая строка будет только одна, или что порядок строк в документе соответствует порядку строк в таблице соответствий
			
			Если СтрокаСоответствий.КоличествоПринято = СтрокаСоответствий.КоличествоВНакладной Тогда
				//если отгуженное и принятое количества совпадают, то нам эта строка не нужна в документе.
				ИмяТабличнойЧасти = Метаданные.НайтиПоТипу(ТипЗнч(НайденнаяСтрока)).Имя;
				Док[ИмяТабличнойЧасти].Удалить(НайденнаяСтрока);
				
			ИначеЕсли СтрокаСоответствий.КоличествоПринято < СтрокаСоответствий.КоличествоВНакладной Тогда
				//Приняли меньше, чем отгружали. Оставим строку в документе возврата
				
				ТребуетсяПересчетПоТабличнойЧасти = Истина;
				
				НайденнаяСтрока.Количество = СтрокаСоответствий.КоличествоВНакладной - СтрокаСоответствий.КоличествоПринято;
				НайденнаяСтрока.Цена = ?(СуммаВключаетНДС,СтрокаСоответствий.ЦенаСНДСВНакладной,СтрокаСоответствий.ЦенаБезНДСВНакладной);
				//здесь нам не нужны цены из RECADV - будем подставлять цены из исходной Реализации, что выглядит более логичным.
				
				Если ИмяКонфигурации1С = "ТКПТ" Тогда
					НайденнаяСтрока.КоличествоБазовое = НайденнаяСтрока.Количество; 		     		
				КонецЕсли;
				
				ПересчитатьСтрокуДокумента(НайденнаяСтрока,Док);
					
			ИначеЕсли СтрокаСоответствий.КоличествоПринято > СтрокаСоответствий.КоличествоВНакладной Тогда
				//это третий возможный случай, и тут мы не можем создать возврат товаров, поскольку в возврате появятся отрицательные количества
				СписокОшибок=?(СписокОшибок="","",СписокОшибок+Символы.ПС)+
				"Товар """+СтрокаСоответствий.Номенклатура+""" принят сетью в количестве "+СтрокаСоответствий.КоличествоПринято+", а отгружался в количестве "+СтрокаСоответствий.КоличествоВНакладной+".";
				
			КонецЕсли;
			
			//Дикий случай! Данного товара нет в реализации, но есть в приемке. 	Мы не сможем в возврат это закинуть! 
		ИначеЕсли СтрокаСоответствий.КоличествоПринято<>0 Тогда
			
			СтрокаСообщения=ТоварыСообщения.Получить(ТабСоответствий.Индекс(СтрокаСоответствий));
			
			СписокОшибок=?(СписокОшибок="","",СписокОшибок+Символы.ПС)+
			"Товар """+СтрокаСоответствий.Номенклатура+""" принят сетью, но не отгружался.";
			
		КонецЕсли;
			
	КонецЦикла;//по строкам
	
КонецПроцедуры	

Процедура ЗаполнитьТоварыДокумента_КорректировкаРеализации(Док,ТабСоответствий,ВариантЗаполнения)
	
	СуммаВключаетНДС = ПолучитьРеквизитДокументаДляСообщения(Док,"СуммаВключаетНДС");
	
	МассивНеобработанныхСтрокКорректировки = Новый Массив;
	
	//пройдемся по строкам
	Для Каждого СтрокаСоответствий Из ТабСоответствий Цикл
		
		//поищем строку с таким товаром в документе
		НайденнаяСтрока = НайтиСоответствиеСтрокиВДокументе(СтрокаСоответствий,Док);
		
		//нашли или не нашли строку в документе. Обработаем это
		
		Если ОтправлятьВозвратнуюТаруВDESADV И НайденнаяСтрока=Неопределено Тогда
			//поищем в возвратной таре
			//она присутствует во всех типовых конфигурациях, но в ней нет ни серий, ни характеристик, ни НДС
			
			//Внимание! В документе "Корректировка реализации" нет табличной части "Возвратная тара"
			//этот случай переложим на подключаемый модуль.
			МассивНеобработанныхСтрокКорректировки.Добавить(СтрокаСоответствий);
			//вроде даже этого не надо
			//Продолжить;
		КонецЕсли;
		
		Если НайденнаяСтрока <> Неопределено Тогда
			//Если переносим расхождения в исходный документ, то строки с нулевым принятым количеством удаляем Из документа.
			Если (СтрокаСоответствий.КоличествоПринято = 0) 
				И ВариантЗаполнения = "Реализация"
				Тогда
				ИмяТабличнойЧасти = Метаданные.НайтиПоТипу(ТипЗнч(НайденнаяСтрока)).Имя;
				Док[ИмяТабличнойЧасти].Удалить(НайденнаяСтрока);
			Иначе //КоличествоПринято<>0, нам надо изменить Количество в строке документа, а также при необходимости перезаполнить/пересчитать цены
				ТребуетсяПересчетПоТабличнойЧасти = Ложь;
				
				Если СтрокаСоответствий.КоличествоПринято <> НайденнаяСтрока.Количество Тогда
					НайденнаяСтрока.Количество = СтрокаСоответствий.КоличествоПринято;
					Если ИмяКонфигурации1С = "ТКПТ" Тогда
						НайденнаяСтрока.КоличествоБазовое = НайденнаяСтрока.Количество; 		     		
					КонецЕсли;
					ТребуетсяПересчетПоТабличнойЧасти = Истина;
				КонецЕсли;
				
				Если СверятьВRECADVЦеныИСтавки Тогда
					
					//проверяем на нулевые значения цену и сумму Из RECADV, которыми при несовпадении с ценами по РТУ хотим перезаполнять текущую позицию
					//будем полагать, что Если цена или сумма нулевая, то ее не отправила сеть, следовательно не будем перезаполнять цену и сумму по текущей позиции
					
					_Цена = ?(СуммаВключаетНДС,СтрокаСоответствий.ЦенаСНДСПринято,СтрокаСоответствий.ЦенаБезНДСПринято);
					_Сумма = ?(СуммаВключаетНДС,СтрокаСоответствий.СуммаСНДСПринято,СтрокаСоответствий.СуммаБезНДСПринято);
					
					Если _Цена <> НайденнаяСтрока.Цена и _Цена <> 0 Тогда
						НайденнаяСтрока.Цена = _Цена;
						ТребуетсяПересчетПоТабличнойЧасти = Истина;
					КонецЕсли;
					
				КонецЕсли;	
				
				Если ТребуетсяПересчетПоТабличнойЧасти Тогда	
					ПересчитатьСтрокуДокумента(НайденнаяСтрока,Док);
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли СтрокаСоответствий.КоличествоПринято<>0 Тогда
			//Ее нашли такую строку в документе Реализация/Корректировка Реализации, придется ее добавить
			//Сначала поищем ее в документе-основании. Если это Возвратная Тара, то не будем добавлять
			Если ВариантЗаполнения = "КорректировкаРеализации"
				И ОтправлятьВозвратнуюТаруВDESADV
				И ТипЗнч(Док.ДокументРеализации)=Тип("ДокументСсылка.РеализацияТоваровУслуг")
				И Док.ДокументРеализации.ВозвратнаяТара.Найти(СтрокаСоответствий.Номенклатура,"Номенклатура")<>Неопределено
				Тогда
				Продолжить;//эту строку не надо добавлять в КорректировкуРеализации, ее будем обрабатывать в подключаемом модуле
			КонецЕсли;	
			
			
			НоваяСтрока = Док.Товары.Добавить();
			НоваяСтрока.Номенклатура		= СтрокаСоответствий.Номенклатура;
			Если Не (ИмяКонфигурации1С = "БП" и ВариантЗаполнения = "КорректировкаРеализации") Тогда
				//в БП нет такого реквизита в документе "Корректировка реализации"
				НоваяСтрока.ЕдиницаИзмерения	= СтрокаСоответствий.ЕдиницаИзмерения;
			КонецЕсли;	
			
			Если ИмяКонфигурации1С <> "БП" Тогда
				НоваяСтрока.Коэффициент			= СтрокаСоответствий.ЕдиницаИзмерения.Коэффициент;
				НоваяСтрока.ХарактеристикаНоменклатуры	= СтрокаСоответствий.ХарактеристикаНоменклатуры;
			КонецЕсли;
			
			НоваяСтрока.Количество			= СтрокаСоответствий.КоличествоПринято;
			Если ИмяКонфигурации1С = "ТКПТ" Тогда
				НоваяСтрока.КоличествоБазовое = НоваяСтрока.Количество; 		     		
			КонецЕсли;
			
			НоваяСтрока.Цена	= ?(СуммаВключаетНДС, СтрокаСоответствий.ЦенаСНДСПринято, СтрокаСоответствий.ЦенаБезНДСПринято );
			НоваяСтрока.Сумма	= ?(СуммаВключаетНДС, СтрокаСоответствий.СуммаСНДСПринято, СтрокаСоответствий.СуммаБезНДСПринято );  //а сумма НДС???
			
		КонецЕсли;
	КонецЦикла;//по строкам
	
КонецПроцедуры	

//}#КонецОбласти Сервисные_Функции


ИспользуютсяХарактеристики		= (ПолучитьТипЗначенияОбъекта("ХарактеристикаНоменклатуры")<>Неопределено);
ИспользуютсяСерии				= НЕ ИмяКонфигурации1С = "БП";
Сообщение =  ПрочитатьСообщение(СообщениеСсылка);
Если ЗначениеЗаполнено(Сообщение) И Сообщение.Свойство("Партнер") И ЗначениеЗаполнено(Сообщение.Партнер) Тогда 
	ОтправлятьВозвратнуюТаруВDESADV	= (ПолучитьЗначениеСвойстваОбъектаEDI(Сообщение.Партнер,"ОтправлятьВозвратнуюТаруВDESADV")=Истина);
Иначе
	ОтправлятьВозвратнуюТаруВDESADV	= ложь;
КонецЕсли;
СписокОшибок="";	