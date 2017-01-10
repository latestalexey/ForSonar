﻿&НаСервере
Перем ОбработкаОбъект;

&НаСервере
//инициализация модуля и его экспортных функций
Функция МодульОбъекта()

	Если ОбработкаОбъект=Неопределено Тогда
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
	КонецЕсли;	
	
	Возврат ОбработкаОбъект;
	
КонецФункции 


&НаКлиенте
Процедура КоманднаяПанельСоответствующейНоменклатурыДобавить(Команда)
	// выбираем из справочника
	ВыбраннаяНоменклатура = ПустаяНоменклатура();  
	
	Если Параметры.МодальностьЗапрещена Тогда
		Выполнить("ПоказатьВводЗначения(Новый ОписаниеОповещения(""ОбработчикДобавитьНовуюНоменклатуруВызовСервера"",ЭтаФорма), ВыбраннаяНоменклатура)");//в активный элемент//, Элемент) 
	иначе
		Если ВвестиЗначение(ВыбраннаяНоменклатура) Тогда
			ОбработчикДобавитьНовуюНоменклатуруВызовСервера(ВыбраннаяНоменклатура);
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПустаяНоменклатура()
	возврат Справочники.Номенклатура.ПустаяСсылка();
КонецФункции

&НаКлиенте
Процедура ОбработчикВводаЗначенияНоменклатуры(ВыбранноеЗначение,Параметры) Экспорт
	ДобавитьНовуюНоменклатуруСервер(ВыбранноеЗначение);	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикДобавитьНовуюНоменклатуруВызовСервера(ВыбраннаяНоменклатура,Доп=Неопределено)Экспорт
	ДобавитьНовуюНоменклатуруСервер(ВыбраннаяНоменклатура);
	
	//активируем её чтобы кнопкой "удалить" можно было пользоваться сразу 
	КоличествоСтрок=СписокНоменклатуры.Количество();
	Если КоличествоСтрок>0 Тогда 
		Элементы.СписокНоменклатуры.ТекущаяСтрока = СписокНоменклатуры.Получить(КоличествоСтрок-1).ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры

&НаСервере 
Процедура ДобавитьНовуюНоменклатуруСервер(ВыбраннаяНоменклатура)
	
	ТипНоменклатуры = МодульОбъекта().ПолучитьТипЗначенияОбъекта("Номенклатура");
	
		Если ЗначениеЗаполнено(ВыбраннаяНоменклатура) Тогда
			НоваяСтрока = СписокНоменклатуры.Добавить();
			НоваяСтрока.Номенклатура = ВыбраннаяНоменклатура;
			Если ИмяКонфигурации1С = "УФ_УТ" или ИмяКонфигурации1С = "УФ_УНФ" Тогда
				НоваяСтрока.ЕдиницаИзмерения = УФ_БазоваяЕИ(ВыбраннаяНоменклатура);
				НоваяСтрока.ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
			ИначеЕсли ИмяКонфигурации1С = "УФ_БП" Тогда
				НоваяСтрока.ЕдиницаИзмерения = ВыбраннаяНоменклатура.ЕдиницаИзмерения;
			ИначеЕсли НЕ ИмяКонфигурации1С = "БП" Тогда
				НоваяСтрока.ЕдиницаИзмерения = ВыбраннаяНоменклатура.ЕдиницаХраненияОстатков;
				НоваяСтрока.ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
			Иначе
				НоваяСтрока.ЕдиницаИзмерения = ВыбраннаяНоменклатура.БазоваяЕдиницаИзмерения;
			КонецЕсли;

			ПроставитьКодИАртикулПоСтроке(НоваяСтрока);
			
			ПроверитьНедобавленныеТовары();
			
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельСоответствующейНоменклатурыУдалить(Команда)
	Если Элементы.СписокНоменклатуры.ТекущиеДанные<>Неопределено Тогда 
		СписокНоменклатуры.Удалить(Элементы.СписокНоменклатуры.ТекущиеДанные);
	Иначе
		Сообщить("Выберите строку соответствия для удаления");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельСоответствующейНоменклатурыУстановитьОсновным(Команда)
	Для Каждого СтрокаТЧ из СписокНоменклатуры Цикл
		СтрокаТЧ.Основной = Ложь; 
	КонецЦикла;
	
	ТекСтрока = Элементы.СписокНоменклатуры.ТекущиеДанные;
	
	Если НЕ ТекСтрока = Неопределено Тогда
		
		ТекСтрока.Основной = Истина;
		
	КонецЕсли;
	
	ПроверитьНаличиеОсновнойНоменклатуры();	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.МодальностьЗапрещена=МодульОбъекта().МодальностьЗапрещена();
	ПутьКФормам = МодульОбъекта().Метаданные().ПолноеИмя() + ".Форма.";
	ИмяКонфигурации1С = МодульОбъекта().определитьКонфигурацию();
	ЕстьАртикул = Метаданные.Справочники.Номенклатура.Реквизиты.Найти("Артикул")<>Неопределено;
	
	Наименование = Параметры.Наименование;
	GTIN = Параметры.GTIN;
	КодТовараПартнера = Параметры.КодТовараПартнера;
	ТорговаяСеть = Параметры.Партнер;
	//
	//+
	ТекущееСоответствие = Новый Структура;
	ТекущееСоответствие.Вставить("GTIN",				Параметры.GTIN);
	ТекущееСоответствие.Вставить("КодТовараПартнера",	Параметры.КодТовараПартнера);
	//-
	
	УстановитьТипКолонки1С("Номенклатура");
	УстановитьТипКолонки1С("ХарактеристикаНоменклатуры");
	УстановитьТипКолонки1С("ЕдиницаИзмерения");

	////// + Внешнее хранилище. kns 2014.08.22
	////Если МодульОбъекта().ВнешнееХранилище Тогда
	////	Элементы.ТорговаяСеть.Заголовок = СокрЛП(СоединениеСХранилищем.ЗначениеИзСтрокиВнутр(Партнер).Наименование);
	////Иначе
	////// - Внешнее хранилище. kns 2014.08.22
	////	Элементы.ТорговаяСеть.Заголовок = СокрЛП(Партнер);
	////КонецЕсли;
	//
	СоответствиеТоваров = МодульОбъекта().СоответствиеТоваров_НайтиНоменклатуру(Параметры.GTIN,Параметры.КодТовараПартнера,Параметры.Партнер);
	
	Если ЗначениеЗаполнено(СоответствиеТоваров) Тогда
		
		Для каждого Стр Из СоответствиеТоваров Цикл
			НоваяСтрока = СписокНоменклатуры.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
			ПроставитьКодИАртикулПоСтроке(НоваяСтрока);			
			Если НЕ МодульОбъекта().ОпределитьКонфигурацию() = "УФ_БП" Тогда
				Если НЕ ЗначениеЗаполнено(Стр.ХарактеристикаНоменклатуры) Тогда
					НоваяСтрока.ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
				КонецЕсли;
			КонецЕсли;
			ЗаполнитьРеквизитыПересчетаКорректно(НоваяСтрока, Стр);
		КонецЦикла;
		
	КонецЕсли;
	
	// автотесты
	Если ЗначениеЗаполнено(Параметры.ПараметрыАвтотестирования) Тогда
		
		ТипНоменклатуры		= МодульОбъекта().ПолучитьТипЗначенияОбъекта("Номенклатура");
		ТипЕдиницыИзмерения	= МодульОбъекта().ПолучитьТипЗначенияОбъекта("ЕдиницаИзмерения");
        ТипНоменклатуры		= СтрЗаменить(ТипНоменклатуры,		"СправочникСсылка.","");
        ТипЕдиницыИзмерения = СтрЗаменить(ТипЕдиницыИзмерения,	"СправочникСсылка.","");
		
		СтруктураПараметров = ПолучитьИзВременногоХранилища(Параметры.ПараметрыАвтотестирования);
		СоответствиеТоваровАвтотестов = СтруктураПараметров.Настройки.Партнер.СоответствияТоваров;

		Для Каждого СтрТоваров Из СоответствиеТоваровАвтотестов Цикл
			Если (СокрЛП(СтрТоваров.GTIN) = СокрЛП(GTIN)) И (СокрЛП(СтрТоваров.КодТовараПартнера) = СокрЛП(КодТовараПартнера)) Тогда
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = Справочники[ТипНоменклатуры].НайтиПоКоду(СтрТоваров.Номенклатура);
				Если ЗначениеЗаполнено(ТипЕдиницыИзмерения) Тогда
					НоваяСтрока.ЕдиницаИзмерения = Справочники[ТипЕдиницыИзмерения].НайтиПоКоду(СтрТоваров.ЕдиницаИзмерения);
				Иначе
					Если ЗначениеЗаполнено(НоваяСтрока.Номенклатура) Тогда
						НоваяСтрока.ЕдиницаИзмерения = НоваяСтрока.Номенклатура.ЕдиницаДляОтчетов;
					КонецЕсли;
				КонецЕсли;
				НоваяСтрока.Основной = СтрТоваров.ОсновноеСоответствие;
				НоваяСтрока.ЕдиницаEDI = СтрТоваров.ЕдиницаEDI;
				НоваяСтрока.ДействиеПересчета = СтрТоваров.ДействиеПересчета;
				НоваяСтрока.КоэффициентEDIВ1С = СтрТоваров.КоэффициентEDI;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	ПроверитьНедобавленныеТовары();
	
	ОформитьПодсказкиЭлементовУправления();
	
	Если МодульОбъекта().ПолучитьЗначениеСвойстваОбъектаEDI(Параметры.Партнер, "НесколькоТоваровСетиНаОдинТоварПоставщика") = Истина Тогда
		Элементы.СписокНоменклатурыКонтрагент.Видимость = Истина;
		Элементы.СписокНоменклатурыДоговор.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьПодсказкиЭлементовУправления()

	Если МодульОбъекта().ПолучитьЗначениеСвойстваОбъектаEDI(Параметры.Партнер, "СинхронизироватьТоварыТолькоПоGTIN") = Истина ТОгда
		Элементы.НадписьЕстьОсобенности.Видимость = Истина;
		Элементы.КартинкаКодПартнера.Видимость = истина;
	ИначеЕсли МодульОбъекта().ПолучитьЗначениеСвойстваОбъектаEDI(Параметры.Партнер, "СинхронизироватьТоварыТолькоПоКодуПартнера") = Истина Тогда
		Элементы.НадписьЕстьОсобенности.Видимость = Истина;
		Элементы.КартинкаGTIN.Видимость = истина;
	КонецЕсли;	

КонецПроцедуры // ОформитьПодсказкиЭлементовУправления()


&НаСервере
Процедура ЗаполнитьРеквизитыПересчетаКорректно(СтрокаНаФорме, СтрокаСоответствия)
	
	Если Не ЗначениеЗаполнено(СтрокаСоответствия.КоэффициентEDIВ1С) Тогда
		СтрокаНаФорме.КоэффициентEDIВ1С = 0;
	Иначе
		СтрокаНаФорме.КоэффициентEDIВ1С = Макс(СтрокаСоответствия.КоэффициентEDIВ1С, -СтрокаСоответствия.КоэффициентEDIВ1С);
	КонецЕсли;
	
	СтрокаНаФорме.ДействиеПересчета = "умножить";
	
	Если ЗначениеЗаполнено(СтрокаСоответствия.КоэффициентEDIВ1С)
		И СтрокаСоответствия.КоэффициентEDIВ1С < 0 Тогда
		СтрокаНаФорме.ДействиеПересчета = "разделить";				
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаНаФорме.ЕдиницаEDI) Тогда
		СтрокаНаФорме.ЕдиницаEDI = "";		 
	КонецЕсли;
			
	//не будем показывать пользователю лишнего
	Если СтрокаНаФорме.ЕдиницаEDI = "" Тогда
		СтрокаНаФорме.ДействиеПересчета = "";
		СтрокаНаФорме.КоэффициентEDIВ1С = 0;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено(Параметры.Партнер) Тогда
		Если Параметры.МодальностьЗапрещена = истина Тогда
			Выполнить("ПоказатьПредупреждение(Новый ОписаниеОповещения(""ОбработчикЗакрытьФорму"", ЭтаФорма,),""Для установки соответствий номенклатуры в форму должен быть передан партнер."");");
		Иначе
			Предупреждение("Для установки соответствий номенклатуры в форму должен быть передан партнер.");
		КонецЕсли;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПроверитьНаличиеОсновнойНоменклатуры();	
	
	Если ЗначениеЗаполнено(Параметры.ПараметрыАвтотестирования) Тогда
		ВыполнитьНажатие("");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеОсновнойНоменклатуры()
	
	Если СписокНоменклатуры.Количество()>0 Тогда
		
		НайденнаяСтрока = Неопределено;
		Для Каждого СтрокаТЧ из СписокНоменклатуры Цикл
			Если СтрокаТЧ.Основной Тогда 
				НайденнаяСтрока=СтрокаТЧ;
			КонецЕсли;
			
		КонецЦикла;
		
		
		Если НайденнаяСтрока = Неопределено Тогда
			
			СписокНоменклатуры[0].Основной = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипКолонки1С(ИмяПоля)
	
	ПолеФормы	= Элементы["СписокНоменклатуры"+ИмяПоля];
	ТипПоля		= МодульОбъекта().ПолучитьТипЗначенияОбъекта(ИмяПоля);
	
	ВХ = МодульОбъекта().ВнешнееХранилище;
	
	Если ТипПоля = Неопределено ИЛИ (ВХ И Найти(ТипПоля,"КонтурEDI_")>0) Тогда
		//Сообщить("Не задан тип объекта 1С для поля с типом "+Тип1С);
	Иначе	
		
		Элементы["СписокНоменклатуры"+ИмяПоля].ОграничениеТипа = Новый ОписаниеТипов(ТипПоля);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СоставитьСписокНоменклатурыЕдиницаEDI()
	Возврат МодульОбъекта().ПолучитьСписокЕдиницEDI();
КонецФункции

&НаСервере
Функция СоставитьСписокНоменклатурыДействиеПересчета()
	Возврат МодульОбъекта().ПолучитьСписокДействийПересчета();
КонецФункции


&НаКлиенте
Процедура СписокНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ИмяКолонки=Поле.Имя;
	Если ИмяКолонки = "СписокНоменклатурыЕдиницаEDI" Тогда
		Состояние("Собираю список");
		СписокВыбора = СоставитьСписокНоменклатурыЕдиницаEDI();
		Если Параметры.МодальностьЗапрещена Тогда
			Выполнить("ПоказатьВыборИзМеню(Новый ОписаниеОповещения(""ОбработчикВыбораСоответствияИзМенюЕдиницаEDI"",ЭтаФорма), СписокВыбора)");//в активный элемент//, Элемент) 
		иначе
			ВыбранноеЗначение = ВыбратьИзМеню(СписокВыбора,Элемент);
			ОбработчикВыбораСоответствияИзМенюЕдиницаEDI(ВыбранноеЗначение,неопределено)
		КонецЕсли;
		СтандартнаяОбработка=Ложь;
	ИначеЕсли ИмяКолонки = "СписокНоменклатурыДействиеПересчета" Тогда
		Состояние("Собираю список");
		СписокВыбора = СоставитьСписокНоменклатурыДействиеПересчета();
		Если Параметры.МодальностьЗапрещена Тогда
			Выполнить("ПоказатьВыборИзМеню(Новый ОписаниеОповещения(""ОбработчикВыбораСоответствияИзМенюДействиеПересчета"",ЭтаФорма), СписокВыбора)");//в активный элемент//, Элемент) 
		иначе
			ВыбранноеЗначение = ВыбратьИзМеню(СписокВыбора,Элемент);
			ОбработчикВыбораСоответствияИзМенюДействиеПересчета(ВыбранноеЗначение,неопределено)
		КонецЕсли;
		СтандартнаяОбработка=Ложь;
	КонецЕсли;
	
КонецПроцедуры
		
&НаКлиенте
Процедура ОбработчикВыбораСоответствияИзМенюДействиеПересчета(ВыбранноеЗначение,Параметры) Экспорт//!
	Если НЕ ВыбранноеЗначение = Неопределено Тогда
		Элементы.СписокНоменклатуры.ТекущиеДанные.ДействиеПересчета				= ВыбранноеЗначение.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВыбораСоответствияИзМенюЕдиницаEDI(ВыбранноеЗначение,Параметры) Экспорт//!
	Если НЕ ВыбранноеЗначение = Неопределено Тогда
		Элементы.СписокНоменклатуры.ТекущиеДанные.ЕдиницаEDI				= ВыбранноеЗначение.Значение;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверитьНедобавленныеТовары()
	
    НедобавленныеТовары = ПолучитьТоварыПоКодуШтрихкоду();
	
	Если НедобавленныеТовары.Количество() = 0 Тогда
		Элементы.ПанельНайденныхПоШтрихкоду.Видимость = Ложь;
	Иначе
		Элементы.ПанельНайденныхПоШтрихкоду.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТоварыПоКодуШтрихкоду()
	
	НедобавленныеТовары = Новый ТаблицаЗначений;
	НедобавленныеТовары.Колонки.Добавить("Код",,"Код");
	
	ЕстьАртикул = (Метаданные.Справочники.Номенклатура.Реквизиты.Найти("Артикул")<>Неопределено);
	Если ЕстьАртикул Тогда
		НедобавленныеТовары.Колонки.Добавить("Артикул",,"Артикул");
	КонецЕсли;	
	
	НедобавленныеТовары.Колонки.Добавить("Номенклатура",,"Номенклатура");
	НедобавленныеТовары.Колонки.Добавить("ХарактеристикаНоменклатуры",,"Характеристика номенклатуры");
	НедобавленныеТовары.Колонки.Добавить("ЕдиницаИзмерения",,"Единица измерения");
	
	Если ЗначениеЗаполнено(GTIN) Тогда
		
		НайденныеТоварыПоШК = МодульОбъекта().НайтиТоварыПоШтрихкоду(СокрЛП(GTIN));
		Если ТипЗнч(НайденныеТоварыПоШК) = Тип("ТаблицаЗначений") Тогда
			Для каждого Стр Из НайденныеТоварыПоШК Цикл
				Нашли = Ложь;
				// сверим в лоб, чтобы не перемудрить с типами колонок и их значениями
				Для Каждого ТекСтр Из СписокНоменклатуры Цикл
					Если Стр.Номенклатура = ТекСтр.Номенклатура Тогда
						Если Стр.ЕдиницаИзмерения = ТекСтр.ЕдиницаИзмерения Тогда
							Нашли = Истина;
							Если ЗначениеЗаполнено(Стр.ХарактеристикаНоменклатуры) И ЗначениеЗаполнено(ТекСтр.ХарактеристикаНоменклатуры) Тогда
								Если НЕ Стр.ХарактеристикаНоменклатуры = ТекСтр.ХарактеристикаНоменклатуры Тогда
									Нашли = Ложь;
								КонецЕсли;
							ИначеЕсли ЗначениеЗаполнено(Стр.ХарактеристикаНоменклатуры) ИЛИ ЗначениеЗаполнено(ТекСтр.ХарактеристикаНоменклатуры) Тогда
								Нашли = Ложь;
							КонецЕсли;
						КонецЕсли;	
					КонецЕсли;
				КонецЦикла;
				Если Нашли = Ложь Тогда
					НоваяСтрока = НедобавленныеТовары.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
					НоваяСтрока.Код = НоваяСтрока.Номенклатура.Код;
					
					Если ЕстьАртикул Тогда
						НоваяСтрока.Артикул = НоваяСтрока.Номенклатура.Артикул;
					КонецЕсли;	
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;		
	
	//сеть указала internalSupplierCode, попробуем найти этот товар в справочнике поставщика по его коду
	Если ЗначениеЗаполнено(КодТовараВнутренний) 
		И ЗначениеЗаполнено(Справочники.Номенклатура.НайтиПоКоду(КодТовараВнутренний))
	Тогда
		НоваяСтрока = НедобавленныеТовары.Добавить();
		НоваяСтрока.Номенклатура = Справочники.Номенклатура.НайтиПоКоду(КодТовараВнутренний);
		НоваяСтрока.Код = НоваяСтрока.Номенклатура.Код;
		Если ЕстьАртикул Тогда
			НоваяСтрока.Артикул = НоваяСтрока.Номенклатура.Артикул;
		КонецЕсли;	
		
		ИмяКонфигурации1С=МодульОбъекта().ОпределитьКонфигурацию();
		
		Если НЕ ИмяКонфигурации1С = "УФ_БП" Тогда
			НоваяСтрока.ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
		//единицу не заполняем, пользователь сам укажет нужную
			НоваяСтрока.ЕдиницаИзмерения = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
		Иначе
			НоваяСтрока.ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	//Для УФ_БП поиск будет по справочнику НоменклатураПоставщиков что, конечно несовсем корректно, ведь в этом контексте речь идет скорее о покупателях, однако, клиенты, как оказалось, часто имеют соответствия именно здесь
	Если ЗначениеЗаполнено(КодТовараПартнера) 
		И МодульОбъекта().ИмяКонфигурации1С = "УФ_БП"
		Тогда
		//поиск по спр. Номенклатура поставщиков (там привязка к контрагенту)
		Если ЗначениеЗаполнено(ТорговаяСеть) Тогда 
			//ищем всех контрагентов этой сети
			НайденныеКонтрагентыСети=МодульОбъекта().ПолучитьСписокЭлементовСправочника("ЮрФизЛицаСторонние",ТорговаяСеть);
			Если НайденныеКонтрагентыСети<>Неопределено Тогда //у этой сети есть контрагенты 
				МассивКонтрагентов=НайденныеКонтрагентыСети.ВыгрузитьКолонку("ЮрФизЛицо");
				
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				|	НоменклатураПоставщиков.Номенклатура,
				|	НоменклатураПоставщиков.Артикул,
				|	НоменклатураПоставщиков.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
				|ИЗ
				|	Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
				|ГДЕ
				|	НоменклатураПоставщиков.Владелец В(&МассивКонтрагентов)
				|	И НоменклатураПоставщиков.Артикул = &Артикул";
				
				Запрос.УстановитьПараметр("МассивКонтрагентов",МассивКонтрагентов);
				Запрос.УстановитьПараметр("Артикул",КодТовараПартнера);
				
				Результат = Запрос.Выполнить();
				Выборка = Результат.Выбрать();
				
				Пока Выборка.Следующий() Цикл
					Нашли = Ложь;
					//проверка что уже добавлено
					Для Каждого ТекСтр Из СписокНоменклатуры Цикл
						Если Выборка.Номенклатура = ТекСтр.Номенклатура Тогда
							Если Выборка.ЕдиницаИзмерения = ТекСтр.ЕдиницаИзмерения Тогда
								Нашли = Истина;
							КонецЕсли;	
						КонецЕсли;
					КонецЦикла;
					//
					Если Нашли = Ложь Тогда
						НоваяСтрока = НедобавленныеТовары.Добавить();
						НоваяСтрока.Номенклатура = Выборка.Номенклатура;
						НоваяСтрока.Код = НоваяСтрока.Номенклатура.Код;
						НоваяСтрока.Артикул = Выборка.Артикул;
						НоваяСтрока.ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НедобавленныеТовары;
	
КонецФункции


&НаКлиенте
Процедура НадписьДобавитьНажатие(Элемент)
	
	ДобавитьНедобавленныеСервер();
	ПроверитьНаличиеОсновнойНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНедобавленныеСервер()
	НедобавленныеТовары = ПолучитьТоварыПоКодуШтрихкоду();
	#Если Клиент Тогда 
		//на сервере на клиенте - толстый клиент
		Если НЕ НедобавленныеТовары.ВыбратьСтроку("Данная номенклатура будет добавлена в соответствие:")=Неопределено Тогда //переделать !!!на тонком не заработает!!!
			
			Для каждого Стр Из НедобавленныеТовары Цикл
				НоваяСтрока = СписокНоменклатуры.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
			КонецЦикла;
			
		КонецЕсли;
	#Иначе
		//просто все закинем не спрашивая
		Для каждого Стр Из НедобавленныеТовары Цикл
			НоваяСтрока = СписокНоменклатуры.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
		КонецЦикла;
		
	#КонецЕсли
		ПроверитьНедобавленныеТовары();
	
КонецПроцедуры

&НаСервере
Функция УФ_БазоваяЕИ(Номенклатура)
	Возврат МодульОбъекта().УФ_ПолучитьБазовуюЕдиницуИзмерения(Номенклатура);
КонецФункции

&НаКлиенте
Процедура СписокНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПередУдалением(Элемент, Отказ)
	Отказ = истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыЕдиницаИзмеренияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	СписокВыбора= новый СписокЗначений;
	
	УФ_СоставитьСписокЕдиницИзмерения(СписокВыбора,Элементы.СписокНоменклатуры.ТекущиеДанные.Номенклатура);
	
	ВыбранноеЗначение = Неопределено;
	
	Если Параметры.МодальностьЗапрещена Тогда 
		Выполнить("ПоказатьВыборИзСписка(Новый ОписаниеОповещения(""СписокНоменклатурыЕдиницаИзмеренияНачалоВыбораЗавершение"", ЭтаФорма), СписокВыбора,Элемент,)");
	Иначе
		ВыбранноеЗначение = ВыбратьИзСписка(СписокВыбора,Элемент,);
		СписокНоменклатурыЕдиницаИзмеренияНачалоВыбораЗавершение(ВыбранноеЗначение, );
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура СписокНоменклатурыЕдиницаИзмеренияНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
	ВыбранноеЗначение = ВыбранныйЭлемент;
    
    Если ВыбранноеЗначение=неопределено или НЕ ЗначениеЗаполнено(ВыбранноеЗначение.Значение)  Тогда
        Элементы.СписокНоменклатуры.ТекущиеДанные.ЕдиницаИзмерения=УФ_БазоваяЕИ(Элементы.СписокНоменклатуры.ТекущиеДанные.Номенклатура);
    иначе
        Элементы.СписокНоменклатуры.ТекущиеДанные.ЕдиницаИзмерения=ВыбранноеЗначение.Значение;
    КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура УФ_СоставитьСписокЕдиницИзмерения(СписокВыбора,Номенклатура)
	МодульОбъекта().УФ_ЗаполнитьСписокЕдиницИзмерения(Номенклатура,СписокВыбора);
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыНоменклатураПриИзменении(Элемент)
	ИдентификаторТекСтроки = Элементы.СписокНоменклатуры.ТекущиеДанные.ПолучитьИдентификатор();
	СписокНоменклатурыНоменклатураПриИзмененииСервер(ИдентификаторТекСтроки)
КонецПроцедуры

&НаСервере
Процедура СписокНоменклатурыНоменклатураПриИзмененииСервер(ИдентификаторТекСтроки)
	
	ТекСтрока = СписокНоменклатуры.НайтиПоИдентификатору(ИдентификаторТекСтроки);
	ПроставитьКодИАртикулПоСтроке(ТекСтрока);
	
	Если ТекСтрока<>Неопределено Тогда 
		Если ИмяКонфигурации1С = "БП" или ИмяКонфигурации1С = "УФ_БП" Тогда
			ТекСтрока.ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка();
		ИначеЕсли МодульОбъекта().ОпределитьРелизКонфигурации()="11.2" Тогда
			ТекСтрока.ЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
		Иначе
			ТекСтрока.ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
			ТекСтрока.ЕдиницаИзмерения = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекСтрока.Номенклатура) Тогда 
			ТекСтрока.ЕдиницаИзмерения = УФ_БазоваяЕИ(ТекСтрока.Номенклатура);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПроставитьКодИАртикулПоСтроке(ТекСтрока)
			ТекСтрока.Код = ТекСтрока.Номенклатура.Код;
			Если ЕстьАртикул=истина Тогда 
				ТекСтрока.Артикул = ТекСтрока.Номенклатура.Артикул;
			КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьНажатие(Команда)
	Если Не ЗначениеЗаполнено(GTIN) И Не ЗначениеЗаполнено(КодТовараПартнера) Тогда
		СообщениеПользователю=Новый СообщениеПользователю;
		СообщениеПользователю.Текст="Необходимо указать GTIN или код товара в торговой сети!";
		СообщениеПользователю.Поле="GTIN";
		СообщениеПользователю.Сообщить();
		Возврат;
	КонецЕсли;
	
	сч = 0;
	Для каждого Стр Из СписокНоменклатуры Цикл
		сч = сч+1;
		НомерТекСтроки=(сч-1);	
		Если НЕ ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			
			СообщениеПользователю=Новый СообщениеПользователю;
			СообщениеПользователю.Текст="В строке "+СокрЛП(НомерТекСтроки)+" не указана номенклатура!";
			СообщениеПользователю.Поле = "СписокНоменклатуры["+Формат(НомерТекСтроки,"ЧГ=")+"].Номенклатура";
			СообщениеПользователю.Сообщить();
			Возврат;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Стр.ЕдиницаИзмерения) Тогда
			
			СообщениеПользователю=Новый СообщениеПользователю;
			СообщениеПользователю.Текст="В строке "+СокрЛП(НомерТекСтроки)+" не указана единица измерения!";
			СообщениеПользователю.Поле = "СписокНоменклатуры["+Формат(НомерТекСтроки,"ЧГ=")+"].ЕдиницаИзмерения";
			СообщениеПользователю.Сообщить();
			Возврат;
			
		КонецЕсли;
		
		Если (ЗначениеЗаполнено(Стр.КоэффициентEDIВ1С)
			или ЗначениеЗаполнено(Стр.ДействиеПересчета))
			И Не ЗначениеЗаполнено(Стр.ЕдиницаEDI) Тогда
			
			СообщениеПользователю=Новый СообщениеПользователю;
			СообщениеПользователю.Текст="В строке "+СокрЛП(НомерТекСтроки)+" не указана единица измерения EDI!";
			СообщениеПользователю.Поле = "СписокНоменклатуры["+Формат(НомерТекСтроки,"ЧГ=")+"].ЕдиницаEDI";
			СообщениеПользователю.Сообщить();
			Возврат;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПроверитьНаличиеОсновнойНоменклатуры();
	
	КоличествоОшибок = СохранитьСоответствиеСервер();
	
	Если КоличествоОшибок = 0 Тогда
		ЭтаФорма.Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СохранитьСоответствиеСервер()
	РезультатСохранения = МодульОбъекта().СоответствиеТоваров_Сохранить(СписокНоменклатуры,GTIN,КодТовараПартнера,Наименование,Параметры.Партнер,ТекущееСоответствие);//+
	КоличествоОшибок=1;
	Если ЗначениеЗаполнено(РезультатСохранения) и РезультатСохранения.ТаблицаОшибок.Количество()=0 Тогда
		КоличествоОшибок=0;
	иначе
		//ошибки уже выведены в МодульОбъекта().СоответствиеТоваров_Сохранить()
	КонецЕсли;	
	Возврат КоличествоОшибок;
КонецФункции


&НаКлиенте
Процедура СписокНоменклатурыЕдиницаEDIНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СписокНоменклатурыВыбор(Элементы.СписокНоменклатуры, Элементы.СписокНоменклатуры.ТекущаяСтрока, Элементы.СписокНоменклатурыЕдиницаEDI, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикЗакрытьФорму(ДополнительныеПараметры) Экспорт
	Если ЭтаФорма.Открыта() Тогда 
		ЭтаФорма.Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыДействиеПересчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СписокНоменклатурыВыбор(Элементы.СписокНоменклатуры, Элементы.СписокНоменклатуры.ТекущаяСтрока, Элементы.СписокНоменклатурыДействиеПересчета, СтандартнаяОбработка);
КонецПроцедуры


&НаКлиенте
Процедура НадписьЕстьОсобенностиНажатие(Элемент)
	
	ТекстПредупреждения = ОписаниеОсобенностейСинхронизацииКодов();
	Если Параметры.МодальностьЗапрещена Тогда 
		Выполнить("ПоказатьПредупреждение(,ТекстПредупреждения,,""EDI.Контур"")");
	Иначе
		Предупреждение(ТекстПредупреждения,,"EDI.Контур");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеОсобенностейСинхронизацииКодов()

	Если МодульОбъекта().ПолучитьЗначениеСвойстваОбъектаEDI(Параметры.Партнер, "СинхронизироватьТоварыТолькоПоGTIN") = Истина Тогда 
		Текст= "У этой торговой сети настроена синхронизация товаров только по GTIN.
		|В исходящих сообщениях код товара покупателя будет взят из ORDERS или RECADV.";	
	ИначеЕсли МодульОбъекта().ПолучитьЗначениеСвойстваОбъектаEDI(Параметры.Партнер, "СинхронизироватьТоварыТолькоПоКодуПартнера") = Истина  Тогда
		Текст= "У этой торговой сети настроена синхронизация товаров только по КОДУ ПАРТНЕРА.
		|При записи соответствия GTIN не будет сохранен. В исходящих сообщениях GTIN будет отправлен из соответствия.";	
	КонецЕсли;
	
    Возврат Текст;
КонецФункции // ОписаниеОсобенностейСинхронизацииКодов()


