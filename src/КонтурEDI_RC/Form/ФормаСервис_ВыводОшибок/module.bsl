﻿
Процедура ПриОткрытии()
	
	ПриОткрытииФормы(ЭтаФорма);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КонтурEDI_АктивизироватьФормуОшибок" Тогда
		
		Активное = Ложь;
		
		Если Параметр = "Открытие" Тогда
			
			Если Источник = ВладелецФормы Тогда
				Активное = Истина;
			КонецЕсли;
			
		ИначеЕсли Параметр = "Закрытие" Тогда
			
			Если НЕ Источник = ВладелецФормы Тогда
				Активное = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Активное Тогда
			ЭлементыФормы.ТаблицаОшибок.ЦветФонаПоля = WebЦвета.Белый;
			Панель.Доступность = Истина;
		Иначе
			ЭлементыФормы.ТаблицаОшибок.ЦветФонаПоля = Новый Цвет(255,255,247);
			Панель.Доступность = Ложь;
		КонецЕсли;
		
	КонецЕсли;

	
КонецПроцедуры

Процедура ТаблицаОшибокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ТаблицаОшибокПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

