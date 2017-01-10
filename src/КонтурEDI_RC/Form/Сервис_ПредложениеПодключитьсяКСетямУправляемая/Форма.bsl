﻿&НаСервере
Перем ОбработкаОбъект;

&НаСервере
//инициализация модуля и его экспортных функций
Функция МодульОбъекта()

	Если ОбработкаОбъект=Неопределено Тогда
		
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
		
		//Если Параметры.АдресХранилища<>"" Тогда
		//	ОбработкаОбъект = ПолучитьИзВременногоХранилища(Параметры.АдресХранилища);
		//	Возврат ОбработкаОбъект;
		//КонецЕсли;
		//
		//Если ОбработкаОбъект=Неопределено Тогда
		//	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		//	ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
		//КонецЕсли;
		//
		//Параметры.АдресХранилища = ПоместитьВоВременноеХранилище(ОбработкаОбъект,УникальныйИдентификатор);
	
	КонецЕсли;	
	
	Возврат ОбработкаОбъект;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для Каждого Сеть Из Параметры.НеподключенныеСети Цикл
		НоваяСтрока = ТаблицаСетей.Добавить();
		НоваяСтрока.ТорговаяСеть = Сеть.Наименование;
		НоваяСтрока.Кнопка = "Подключиться";
		НоваяСтрока.СсылкаНаСайте = Сеть.СсылкаНаСайте;
		НоваяСтрока.Иконка = 0;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ТаблицаСетей.Шапка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСетейПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСетейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСетейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Элементы.ТаблицаСетей.ТекущиеДанные.СсылкаНаСайте) Тогда
		ТекСсылка = "http://www.r-kontur.ru/clients/"+СокрЛП(Элементы.ТаблицаСетей.ТекущиеДанные.СсылкаНаСайте);
	Иначе
		ТекСсылка = "http://www.r-kontur.ru/price";
	КонецЕсли;
	
	ТекСсылка = ТекСсылка + "?GLN="+СокрЛП(Параметры.ОсновнойGLN);
	
	ЗапуститьПриложение(ТекСсылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
   ПередЗакрытиемСервер();
   
КонецПроцедуры

&НаСервере
Процедура ПередЗакрытиемСервер()
	Структура = Новый Структура;
	
	НоваяДатаНапоминания = ТекущаяДата();
	
	Если НеНапоминатьМесяц Тогда
		НоваяДатаНапоминания = ДобавитьМесяц(ТекущаяДата(),1);
	КонецЕсли;
	
	Структура.Вставить("КонтурEDI_ДатаПредложенияПодключенияТС", НоваяДатаНапоминания);
	
	ХранилищеСистемныхНастроек.Сохранить("КонтурEDI_ДатаПредложенияПодключенияТС", , Структура);
	
КонецПроцедуры // ПередЗакрытиемСервер()

