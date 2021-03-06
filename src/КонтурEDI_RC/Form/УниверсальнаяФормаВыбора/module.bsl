﻿
Процедура Выбрать(Кнопка)
	
	//Если выбор 1 значения и флажок не установлен - значит выбрали активную строку
	Если ВыборНесколькихЗначений=Ложь и ФлажокВыбран()=Ложь Тогда 
		ЭлементыФормы.ТаблицаВыбора.ТекущиеДанные.Выбор=Истина;
	ИначеЕсли ВыборНесколькихЗначений=Ложь и ФлажокВыбран()=Ложь Тогда 
		ТекстПредупреждения="Выберите хотя бы одно значение";
		Предупреждение(ТекстПредупреждения,,"EDI.Контур");
		Возврат;
	КонецЕсли;
	
	Если ВыборОбязателен=Истина и ФлажокВыбран()=Ложь Тогда 
		ТекстВопроса ="Значение не выбрано. Вы уверены что хотите отказаться от выбора?";
		КнопкиВопроса=новый СписокЗначений;
		КнопкиВопроса.Добавить("Отказ от выбора");
		КнопкиВопроса.Добавить("Выбрать заново");
		ДопПараметрДляПередачиВОбработчик=Неопределено;
		РезультатВопроса = Неопределено;
		
		РезультатВопроса = Вопрос(ТекстВопроса, КнопкиВопроса,,,"EDI.Контур");
		ОбработчикРешенияОбОтказеВыбора(РезультатВопроса,ДопПараметрДляПередачиВОбработчик);
	Иначе
		
		ПоместитьРезультатВХранилище();	
		ЭтаФорма.Закрыть(АдресТаблицыВХранилище);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработчикРешенияОбОтказеВыбора(РезультатВопроса,ДопПараметрПереданныйВОбработчик=Неопределено) Экспорт

	Если РезультатВопроса="Отказ от выбора" Тогда 
		ПоместитьРезультатВХранилище();	
		ЭтаФорма.Закрыть(АдресТаблицыВХранилище);
	КонецЕсли;

КонецПроцедуры

Функция ПоместитьРезультатВХранилище()

	АдресТаблицыВХранилище = ПоместитьВоВременноеХранилище(ТаблицаВыбора);
    Возврат АдресТаблицыВХранилище;
	
КонецФункции // ПоместитьРезультатВХранилище()

Функция ФлажокВыбран()

	Для Каждого Строка Из ТаблицаВыбора Цикл
		Если Строка.Выбор=Истина Тогда 
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
    Возврат Ложь;
	
КонецФункции // Флажок выбран()

Процедура ПриОткрытии()
	
	ЭтаФорма.Заголовок="Выберите "+?(ВыборНесколькихЗначений," необходимые значения...","одно из предложенных значений...");
	
	ТаблицаЗначений=ПолучитьИзВременногоХранилища(АдресТаблицыВХранилище);
	
	ЗаполнитьПолеФормыДаннымиТаблицы(ТаблицаЗначений);

КонецПроцедуры

Процедура ЗаполнитьПолеФормыДаннымиТаблицы(ТаблицаЗначений)
	
	МассивШириныКолонок = ОпределитьШиринуКолонокПоЗначениюВТЗ(ТаблицаЗначений);
	МассивДобавляемыхРеквизитов = Новый Массив;
	
	НоваяКолонка=ТаблицаВыбора.Колонки.Добавить("Выбор",Новый ОписаниеТипов("Булево"),"Выбор",6);
	
	й=0;
	Для каждого Колонка Из ТаблицаЗначений.Колонки  Цикл
		//вытащить тип из этой колонки и присвоить
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(ТаблицаЗначений[0][й]));
		МассивТипов.Добавить(Тип("Строка"));
		ПараметрыЧисла = Новый КвалификаторыЧисла(15, 2);
		ДопустимыеТипы = Новый ОписаниеТипов(МассивТипов,ПараметрыЧисла);
		
		Если Колонка.Имя <>"Выбор" Тогда
			НоваяКолонка=ТаблицаВыбора.Колонки.Добавить(Колонка.Имя,ДопустимыеТипы,Колонка.Имя,МассивШириныКолонок[й]);
		КонецЕсли;
		
		й=й+1;
	КонецЦикла;
	ЭлементыФормы.ТаблицаВыбора.СоздатьКолонки();
	
	ЭлементыФормы.ТаблицаВыбора.Колонки.Выбор.ДанныеФлажка = "Выбор";
	ЭлементыФормы.ТаблицаВыбора.Колонки.Выбор.Данные = "";
    ЭлементыФормы.ТаблицаВыбора.Колонки.Выбор.Режимредактирования = РежимРедактированияКолонки.Непосредственно;
	
	й=0;
	Для каждого КолонкаЭлементаФормы Из ЭлементыФормы.ТаблицаВыбора.Колонки  Цикл
		//теперь оформим колонки
		Если КолонкаЭлементаФормы.Имя = "Выбор" Тогда 
			//КолонкаЭлементаФормы.ЭлементУправления = Флажок
		Иначе
			КолонкаЭлементаФормы.ТолькоПросмотр=Истина;
		КонецЕсли;
		й=й+1;
	КонецЦикла;
	
	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
		НоваяСтрокаНаФорме=ТаблицаВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаНаФорме,СтрокаТаблицы);
	КонецЦикла;
	
	Если ВыборНесколькихЗначений<>Истина Тогда 
		//прячем колонку выбор
		ЭлементыФормы.ТаблицаВыбора.Колонки.Выбор.Видимость=Ложь;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПолеФормыДаннымиТаблицы()

Функция ОпределитьШиринуКолонокПоЗначениюВТЗ(ТаблицаЗначений)
	
	МассивШирины = новый Массив;
	Для Каждого Колонка из ТаблицаЗначений.Колонки Цикл
		МассивШирины.Добавить(0);	
	КонецЦикла;
		
	Для Каждого СтрокаТЗ из ТаблицаЗначений Цикл
		й=0;
		Для каждого Колонка из ТаблицаЗначений.Колонки Цикл
			ЗначениеТипаСсылка=Ложь;//под ссылку дадим 10 симв
			МаксимальнаяДлинаСодержимого=0;
			
			ТипЯчейкиСтрока = Строка(ТипЗнч(СтрокаТЗ[й]));
			Если Найти(ТипЯчейкиСтрока,"Ссылка")>0 Тогда 
				МассивШирины[й]=7;//под ссылки 7 знаков
			Иначе
				ДлинаСодержимого=СтрДлина(СокрЛП(Строка(СтрокаТЗ[й])));
				МассивШирины[й]= Макс(МассивШирины[й],ДлинаСодержимого);
			КонецЕсли;
			
			й=й+1;
		КонецЦикла;
		
	КонецЦикла;

	Возврат МассивШирины;
КонецФункции // ОпределитьШиринуКолонкиПоЗначениюВней()

Процедура ТаблицаВыбораПриИзмененииФлажка(Элемент, Колонка)
	
	Если ВыборНесколькихЗначений=Ложь Тогда 
		//сбросить остальные флажки
		Для Каждого Строка Из ТаблицаВыбора Цикл
			Строка.Выбор=Ложь;
		КонецЦикла;
		ЭлементыФормы.ТаблицаВыбора.ТекущиеДанные.Выбор=Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаблицаВыбораВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыборНесколькихЗначений<>Истина Тогда 
		//это даблклик при выборе одного из
		Выбрать("");
	КонецЕсли;
	
КонецПроцедуры
