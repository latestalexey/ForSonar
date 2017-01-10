﻿Процедура КоманднаяПанельСпискаКнопкаДобавить(Кнопка)
	
	ФормаТД = ПолучитьФорму("ФормаПользователи_Элемент");
	ФормаТД.Открыть();
	
КонецПроцедуры

Процедура ОбновитьСписокПользователей()
	
	СписокПользователей.Очистить();
	
	СписокЭлементов = ПолучитьСписокЭлементовСправочника("Пользователи");
	
	Для каждого Стр Из СписокЭлементов Цикл
		
		НоваяСтрока = СписокПользователей.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ПриОткрытииФормы(ЭтаФорма);
	
	ОбновитьСписокПользователей();
	
КонецПроцедуры

Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
		
	ТекСтрока = ЭлементыФормы.СписокПользователей.ТекущиеДанные;
	
	Если НЕ ТекСтрока = Неопределено Тогда
	
		ФормаТД = ПолучитьФорму("ФормаПользователи_Элемент");
		ФормаТД.Пользователь = ТекСтрока.Пользователь;
		ФормаТД.Открыть();
	
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КонтурEDI_ОбновитьСписокПользователей" Тогда
		
		ОбновитьСписокПользователей();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СписокПользователейПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Роль = "ПолныеПрава" Тогда
		ОформлениеСтроки.Ячейки.Роль.УстановитьТекст("Полные права");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
		
	//проверим, что в списке содержится хотя бы 1 пользователь, имеющий роль "Полные права"
	Если СписокПользователей.Количество() > 0 Тогда 
		ЕстьПользовательСПолнымиПравами = Ложь;
		Для Каждого Пользователь Из СписокПользователей Цикл
			Если Пользователь.Роль = "ПолныеПрава" Тогда
				ЕстьПользовательСПолнымиПравами = Истина;
			КонецЕсли;
		КонецЦикла;
		Если Не ЕстьПользовательСПолнымиПравами Тогда
			ВывестиПредупреждение_КонтурEDI("В списке пользователей не найден ни один пользователь с ролью ""Полные права""." + Символы.ПС +
								  "Необходимо установить роль ""Полные права"" хотя бы одному из списка пользователей.");
		    Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
