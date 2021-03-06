﻿
Процедура ПриОткрытии()
	
	ПриОткрытииФормы(ЭтаФорма);
	
	ЭлементыФормы.GLN.СписокВыбора = ПолучитьСписокGLNДляОтправкиСообщения();
	
КонецПроцедуры

Процедура ИмяФайлаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = "XML|*.XML";
	Если Диалог.Выбрать() Тогда
		ИмяФайла = Диалог.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтправить(Кнопка)

	Если Не ЗначениеЗаполнено(ИмяФайла) 
		Или Не ЗначениеЗаполнено(GLN) Тогда
		Предупреждение("Укажите имя файла и GLN");
		Возврат;
	КонецЕсли;
	
	Результат = ПередатьСообщениеНаСервер(Новый Структура("ПутьКФайлу,GLN,Успешно",ИмяФайла,GLN,Истина));
	
	Если Результат.Успешно Тогда
		Предупреждение("Сообщение отправлено");
	Иначе
		Предупреждение("Сообщение не отправлено");
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСписокGLNДляОтправкиСообщения()
	
	Результат = Новый СписокЗначений;
	
	Запрос = ИнициализироватьЗапрос_КонтурEDI(ВнешнееХранилище);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	КонтурEDI_ДополнительныеРеквизиты.Значение КАК GLN
	|ИЗ
	|	РегистрСведений.КонтурEDI_ДополнительныеРеквизиты КАК КонтурEDI_ДополнительныеРеквизиты
	|ГДЕ
	|	(КонтурEDI_ДополнительныеРеквизиты.Свойство = ""GLN_Основной""
	|			ИЛИ КонтурEDI_ДополнительныеРеквизиты.Свойство = ""GLN_Организации"")
	|
	|УПОРЯДОЧИТЬ ПО
	|	GLN";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.GLN);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

