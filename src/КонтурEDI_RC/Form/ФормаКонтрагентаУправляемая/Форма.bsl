﻿&НаСервере
Перем ОбработкаОбъект;

Перем ПараметрыПользователяEDI;

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
Процедура ОткрытьФормуОбъектаМодально(ИмяФормы, ПараметрыФормы = Неопределено, ИмяОбработчика = Неопределено, ПараметрыОбработчика = Неопределено, ВладелецОбработчика = Неопределено,РежимБлокирования = Неопределено)
	//отказ от модальности
	Если РежимБлокирования = Неопределено Тогда
		РежимБлокирования=	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если ВладелецОбработчика = Неопределено Тогда
		ВладелецОбработчика=	ЭтаФорма;
	КонецЕсли;
	
	Если ИмяОбработчика = Неопределено Тогда
		ОписаниеОбработчика=	Неопределено;
	Иначе	
		Выполнить("ОписаниеОбработчика=	Новый ОписаниеОповещения(ИмяОбработчика, ВладелецОбработчика, ПараметрыОбработчика)");
	КонецЕсли;
	
	Выполнить("ОткрытьФорму(ИмяФормы, ПараметрыФормы, ВладелецОбработчика, , , ,  ОписаниеОбработчика, РежимБлокирования)");
	
КонецПроцедуры

&НаСервере
Функция ОчиститьПометкиПолейСервер()
	
	Элементы.GLN.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Банк.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Бик.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.ГлавныйБухгалтер.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Город.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Дом.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Имя.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Индекс.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.ИНН.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Квартира.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Корпус.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.КПП.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Наименование.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.НаселенныйПункт.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.НомерСчета.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Район.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Регион.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Руководитель.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Телефон.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Улица.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	Элементы.Фамилия.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяПоляСообщения = Параметры.ИмяПоляСообщения;
	Параметры.МодальностьЗапрещена=МодульОбъекта().МодальностьЗапрещена();
	ПутьКФормам = МодульОбъекта().Метаданные().ПолноеИмя() + ".Форма.";
	Сообщение=ПолучитьИзВременногоХранилища(Параметры.АдресСообщенияВВХ);
	
	
	ОчиститьПометкиПолейСервер();
	
	КтоМы = МодульОбъекта().ОпределитьКемМыЯвляемся(Сообщение);
	
	Если ИмяПоляСообщения = "Покупатель" Тогда
		Если КтоМы = "Поставщик" Тогда
			Элементы.ЮрФизЛицо1С.Заголовок = "Контрагент";
		Иначе
			Элементы.ЮрФизЛицо1С.Заголовок = "Организация";
		КонецЕсли;
	ИначеЕсли ИмяПоляСообщения = "Продавец" Тогда
		Если КтоМы = "Поставщик" Тогда
			Элементы.ЮрФизЛицо1С.Заголовок = "Организация";
		Иначе
			Элементы.ЮрФизЛицо1С.Заголовок = "Контрагент";
		КонецЕсли;
	Иначе
		Элементы.ЮрФизЛицо1С.Заголовок = ИмяПоляСообщения;
	КонецЕсли;
	
	Элементы.ЗаголовокКонтрагента.Заголовок = СокрЛП(Элементы.ЮрФизЛицо1С.Заголовок)+" в 1С";
	
	Если КтоМы = "Поставщик" Тогда
		Если Сообщение.Направление = "Входящее" Тогда
			Элементы.Группа2.Заголовок = "Данные, которые пришли от торговой сети";
		Иначе
			Элементы.Группа2.Заголовок = "Данные, которые будут отправлены в торговую сеть";
		КонецЕсли;
	Иначе
		Если Сообщение.Направление = "Входящее" Тогда
			Элементы.Группа2.Заголовок = "Данные, которые пришли от поставщика";
		Иначе
			Элементы.Группа2.Заголовок = "Данные, которые будут отправлены поставщику";
		КонецЕсли;
	КонецЕсли;
	
	ЮрФизЛицо = Сообщение[ИмяПоляСообщения+"EDI"];
	
	ЮрФизЛицо1С = Сообщение[ИмяПоляСообщения+"1С"];
	
	ЗаполнитьПоляФормы(ЮрФизЛицо);
	
	УстановитьВидимостьПолейЮрФизЛица();
	
	НетОшибок = Истина;
	
	Если Сообщение.Направление = "Исходящее" Тогда
		
		Элементы.ЮрФизЛицо1С.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	НетОшибок = мПроверитьПоляЮрФизЛица();
	
	Если КтоМы = "Поставщик" Тогда
		Если Сообщение.Направление = "Входящее" Тогда
			Если ИмяПоляСообщения = "Покупатель" Тогда
				
				Если ПараметрыПользователяEDI = неопределено Тогда 
					ПараметрыПользователяEDI= МодульОбъекта().ПолучитьПараметрыТекущегоПользователяEDI();
				КонецЕсли;
				
				
				Если НЕ ПараметрыПользователяEDI.ГрузополучательИзЮрФизЛицаТД = Истина Тогда
					
					ТочкаДоставки = МодульОбъекта().ПолучитьЭлементСправочника("ТочкиДоставкиСторонние",Сообщение.Грузополучатель1С);
					
					Если ЗначениеЗаполнено(ТочкаДоставки) И ЗначениеЗаполнено(ТочкаДоставки.ЮрФизЛицо) Тогда
						
						Элементы.ЮрФизЛицо1С.Доступность = Ложь;
						Элементы.НадписьПримечаниеТочкиДоставки.Видимость = Истина;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НетОшибок Тогда
		
		Элементы.ТаблицаОшибок.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоляФормы(ЮрФизЛицо)
	
	ВидЮрФизЛица = ЮрФизЛицо.Вид;
	
	Наименование	= ЮрФизЛицо.Наименование;
	Фамилия			= ЮрФизЛицо.Фамилия;
	Имя				= ЮрФизЛицо.Имя;
	Отчество		= ЮрФизЛицо.Отчество;
	
	Если ЗначениеЗаполнено(ЮрФизЛицо.GLN) Тогда
		GLN = ЮрФизЛицо.GLN;
	КонецЕсли;
	ИНН = ЮрФизЛицо.ИНН;
	КПП = ЮрФизЛицо.КПП;
	
	Банк		= ЮрФизЛицо.Банк;
	БИК			= ЮрФизЛицо.БИК;
	НомерСчета	= ЮрФизЛицо.НомерСчета;
	
	Телефон = ЮрФизЛицо.Телефон;
	
	Руководитель		= ЮрФизЛицо.Руководитель;
	ГлавныйБухгалтер	= ЮрФизЛицо.ГлавныйБухгалтер;
	
	Если Не ЗначениеЗаполнено(ЮрФизЛицо.Адрес) Тогда
		
		ПереключательАдреса = "Российский";
		
	Иначе
		
		ВидАдреса = ЮрФизЛицо.Адрес.ВидАдреса;
		
		Если НЕ ЗначениеЗаполнено(ВидАдреса) Тогда
			ПереключательАдреса = "Российский";
		Иначе
			ПереключательАдреса = ВидАдреса;
		КонецЕсли;
		
		АдресЮрФизЛица = ЮрФизЛицо.Адрес;
		
		Индекс			= АдресЮрФизЛица.Индекс;
		Регион			= АдресЮрФизЛица.Регион;
		Район			= АдресЮрФизЛица.Район;
		Город			= АдресЮрФизЛица.Город;
		НаселенныйПункт = АдресЮрФизЛица.НаселенныйПункт;
		Улица			= АдресЮрФизЛица.Улица;
		Дом				= АдресЮрФизЛица.Дом;
		Корпус			= АдресЮрФизЛица.Корпус;
		Квартира		= АдресЮрФизЛица.Квартира;
		
		КодСтраны		= АдресЮрФизЛица.КодСтраны;
		Адрес			= АдресЮрФизЛица.Адрес;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПолейЮрФизЛица()
	
	Если ВидЮрФизЛица = "ФизЛицо" Тогда
		
		Элементы.СтраницаЮрЛицо.Видимость = ложь;
		Элементы.СтраницаФизЛицо.Видимость = Истина;
		
		Элементы.КПП.Видимость			= Ложь;
		
	Иначе
		
		Элементы.СтраницаЮрЛицо.Видимость = Истина;
		Элементы.СтраницаФизЛицо.Видимость = Ложь;
		
		Элементы.КПП.Видимость			= Истина;
		
	КонецЕсли;		
	
КонецПроцедуры

&НаСервере
Функция мПроверитьПоляЮрФизЛица()
	
	Если Сообщение.Направление = "Исходящее" Тогда
		
		ОбязательныеПоля 	= МодульОбъекта().ПолучитьОбязательныеПоля(Сообщение);
		ТаблицаОшибокПоля	= МодульОбъекта().ИнициализироватьТаблицуОшибок();
		СтруктураСообщения	= МодульОбъекта().ПолучитьМетаданныеПоляСообщения("ЮрФизЛицо");
		
		МодульОбъекта().ПроверитьПоляСообщенияEDI(ЮрФизЛицо, СтруктураСообщения, ТаблицаОшибокПоля, ИмяПоляСообщения+"EDI",,, ОбязательныеПоля);
		
		БылиОшибки = ?(ТаблицаОшибок.Количество()=0, Ложь, Истина);
		
		ТаблицаОшибок.Очистить();
		
		ОчиститьПометкиПолейСервер();
		
		Если НЕ ТаблицаОшибокПоля.Количество()=0 Тогда
			
			Для Каждого Стр Из ТаблицаОшибокПоля Цикл
				
				Если Стр.ИмяПоля = "Адрес" Тогда
					Для каждого СтрАдреса ИЗ Стр.СведенияОбОшибках Цикл
						
						ВывестиСведенияОбОшибке(СтрАдреса);
						
					КонецЦикла;
					
				Иначе
					ВывестиСведенияОбОшибке(Стр);
				КонецЕсли;	
				
			КонецЦикла;
			
			ВывестиПанельИнформации("В данных по этому юр. лицу найдены ошибки, их необходимо исправить перед отправкой.","Плохо");
			
			Элементы.ТаблицаОшибок.Видимость=Истина;
			
			Возврат Ложь;
			
		Иначе
			
			Если БылиОшибки Тогда
				
				ВывестиПанельИнформации(" Поздравляем! Все ошибки исправлены!","Хорошо");
				
			Иначе
				
				Если КтоМы = "Поставщик" Тогда
					ОкончаниеИсходящее	= "в торговую сеть.";
					ОкончаниеВходящее	= "от торговой сети.";
				Иначе
					ОкончаниеИсходящее	= "поставщику.";
					ОкончаниеВходящее	= "от поставщика.";
				КонецЕсли;
				
				Если Сообщение.Направление = "Исходящее" Тогда
					
					ВывестиПанельИнформации("В этой форме вы можете проверить данные, которые будут отправлены "+ОкончаниеИсходящее);
					
				Иначе
					
					ВывестиПанельИнформации("В этом окне вы можете увидеть подробно те данные, которые были отправлены "+ОкончаниеВходящее);
					
				КонецЕсли;
				
			КонецЕсли;
			
			Элементы.ТаблицаОшибок.Видимость=ложь;
			
		КонецЕсли;
		
	Иначе
		Если КтоМы = "Поставщик" Тогда
			ОкончаниеИсходящее	= "в торговую сеть.";
			ОкончаниеВходящее	= "от торговой сети.";
		Иначе
			ОкончаниеИсходящее	= "поставщику.";
			ОкончаниеВходящее	= "от поставщика.";
		КонецЕсли;
		ВывестиПанельИнформации("В этом окне вы можете увидеть подробно те данные, которые были отправлены "+ОкончаниеВходящее,"Хорошо");
		Если НЕ ЗначениеЗаполнено(ЮрФизЛицо1С) Тогда
			
			ИмяПоля = НРег(СокрЛП(Элементы.ЮрФизЛицо1С.Заголовок));
			ИмяПоля = СтрЗаменить(ИмяПоля,"ент","ента"); 
			ИмяПоля = СтрЗаменить(ИмяПоля,"ция","цию"); 
			ИмяПоля = СтрЗаменить(ИмяПоля,"ель","еля"); 
			
			ВывестиПанельИнформации("Для загрузки сообщения выберите "+ИмяПоля+".");
			
		КонецЕсли;	
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ВывестиСведенияОбОшибке(Стр)
	
	НоваяСтрока = ТаблицаОшибок.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
	
	НоваяСтрока.ТекстОшибки = Стр.СведенияОбОшибках;
	
	Если Стр.ИмяПоля = "GLN" Тогда
		
		НоваяСтрока.Действие = "Открыть форму настройки GLN";
		
	Иначе
		
		ИмяПоля = НРег(СокрЛП(Элементы.НадписьЮрФизЛицо1С.Заголовок));
		ИмяПоля = СтрЗаменить(ИмяПоля,"ент","ента");
		ИмяПоля = СтрЗаменить(ИмяПоля,"ция","ции");
		ИмяПоля = СтрЗаменить(ИмяПоля,"ель","еля");
		
		НоваяСтрока.Действие = "Открыть форму "+ИмяПоля;
		
	КонецЕсли;
	
	НайденноеПоле = Элементы.Найти(Стр.ИмяПоля);
	
	Если НЕ НайденноеПоле = Неопределено Тогда
		
		НайденноеПоле.ЦветФона = WebЦвета.Лосось;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиПанельИнформации(Текст,Вид = Неопределено)
	
	// Возможные виды:
	//	- Хорошо
	//	- Плохо
	//	- Нейтрально
	
	
	Если Вид = "Хорошо" Тогда
		
		//Элементы.ПанельИнформации.ЦветФона		= WebЦвета.Роса;
		Элементы.НадписьИнформация.ЦветТекста		= WebЦвета.ЦианТемный;
		//Элементы.ПанельИнформации.ЦветРамки	= WebЦвета.ЗеленыйЛес;
		
		//ЭлементыФормы.ИконкаПанелиИнформации.Картинка = ПолучитьКартинкуEDI("ЭлементФормы","КартинкаГалочка");
		
	ИначеЕсли Вид = "Плохо" Тогда
		
		//Элементы.ПанельИнформации.ЦветФона		= WebЦвета.ТусклоРозовый;
		Элементы.НадписьИнформация.ЦветТекста		= WebЦвета.Киноварь;
		//Элементы.ПанельИнформации.ЦветРамки	= WebЦвета.Шоколадный;
		
		//ЭлементыФормы.ИконкаПанелиИнформации.Картинка = ПолучитьКартинкуEDI("ЭлементФормы","КартинкаИсправитьОшибки");
		
	Иначе	
		
		//Элементы.ПанельИнформации.ЦветФона		= WebЦвета.СлоноваяКость;
		Элементы.НадписьИнформация.ЦветТекста		= WebЦвета.ТемноОранжевый;
		//Элементы.ПанельИнформации.ЦветРамки	= WebЦвета.РыжеватоКоричневый;
		
		//Элементы.ИконкаПанелиИнформации.Картинка = ПолучитьКартинкуEDI("ЭлементФормы","КартинкаИнформация");
		
	КонецЕсли;
		
	Элементы.НадписьИнформация.Заголовок = СокрЛП(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательАдресаПриИзменении(Элемент)
	
	Если ПереключательАдреса = "Российский" Тогда
		
		Элементы.АдресРоссийский.Видимость = Истина;
		Элементы.АдресИностранный.Видимость = Ложь;
		
	Иначе
		
		Элементы.АдресРоссийский.Видимость = Ложь;
		Элементы.АдресИностранный.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЮрФизЛицаПриИзменении(Элемент)
	УстановитьВидимостьПолейЮрФизЛица()
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеДействиеФормыВыполнить(Команда)
	
	Если Сообщение.Направление = "Входящее" Тогда
		
		Если НЕ ЗначениеЗаполнено(ЮрФизЛицо1С) Тогда
			
			ТекстПредупреждения="Не указан "+НРег(ИмяПоляСообщения)+"!";
			
			Если Параметры.МодальностьЗапрещена() Тогда
				Выполнить("ПоказатьПредупреждение(,ТекстПредупреждения)");
			Иначе
				Предупреждение(ТекстПредупреждения);
			КонецЕсли;
			
			Возврат;
		КонецЕсли;
		
		СохранятьСоответствие = Истина;
		
		Если ИмяПоляСообщения = "Грузополучатель" Тогда
			Если КтоМы = "Поставщик" Тогда
				
				ТочкаДоставки = ПолучитьТД();
				
				Если ЗначениеЗаполнено(ТочкаДоставки.ЮрФизЛицо) Тогда
					СохранятьСоответствие = Ложь;
				КонецЕсли;
				
				Если НЕ СокрЛП(ТочкаДоставки.GLN) = СокрЛП(GLN) Тогда
					
					ТекстПредупреждения="GLN выбранной точки доставки ("+СокрЛП(ТочкаДоставки.GLN)+") отличается от GLN, отправленного из торговой сети!";
					
					Если Параметры.МодальностьЗапрещена() Тогда
						Выполнить("ПоказатьПредупреждение(,ТекстПредупреждения)");
					Иначе
						Предупреждение(ТекстПредупреждения);
					КонецЕсли;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
		Сообщение[ИмяПоляСообщения+"1С"] = ЮрФизЛицо1С;
		
		Если СохранятьСоответствие Тогда
			ВыполнитьСохранениеСоответствияСервер();
		КонецЕсли;
		
	Иначе
		
		Сообщение[ИмяПоляСообщения+"EDI"] = ЮрФизЛицо;
		
	КонецЕсли;
	
	АдресВВХИзмененногоСообщения=ЗагрузитьСообщениеВВХ();
	
	СтруктураВозврата = новый Структура;
	СтруктураВозврата.Вставить("Успешно",истина);
	СтруктураВозврата.Вставить("АдресВВХСообщения",АдресВВХИзмененногоСообщения);
	СтруктураВозврата.Вставить("ЮрФизЛицо",ЮрФизЛицо);
	СтруктураВозврата.Вставить("ЮрФизЛицо1С",ЮрФизЛицо1С);
	СтруктураВозврата.Вставить("ИмяПоля",ИмяПоляСообщения);
	                                                   
	ЭтаФорма.Закрыть(СтруктураВозврата);

КонецПроцедуры

&НаСервере
Функция ПолучитьТД()
	
	Возврат МодульОбъекта().ПолучитьЭлементСправочника("ТочкиДоставкиСторонние",ЮрФизЛицо1С);	

КонецФункции // ()

&НаСервере
Процедура ВыполнитьСохранениеСоответствияСервер()
	
	МетаданныеСообщения = МодульОбъекта().ПолучитьМетаданныеСообщения(Сообщение.ТипСообщения,Сообщение.Направление);
	СвойстваПоля = МодульОбъекта().ПолучитьСвойстваПоля(ИмяПоляСообщения,МетаданныеСообщения);
	
	Если СвойстваПоля.ВидСтруктурыEDI = Неопределено Тогда
		ТипEDI = СвойстваПоля.ТипEDI;
	Иначе
		ТипEDI = СвойстваПоля.ВидСтруктурыEDI;
	КонецЕсли;
	
	МодульОбъекта().УстановитьСоответствиеПоляШапки(Сообщение[ИмяПоляСообщения+"1С"],Сообщение[ИмяПоляСообщения+"EDI"],СвойстваПоля.Тип1С,ТипEDI);
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьСообщениеВВХ()
	
	АдресВХ = ПоместитьВоВременноеХранилище(Сообщение,Новый УникальныйИдентификатор);
	
	Возврат АдресВХ;	
	
КонецФункции 

&НаКлиенте
Процедура ЮрФизЛицо1СНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Параметры.ИмяПоляСообщения = "Грузополучатель" Тогда
		Если Сообщение.Направление = "Входящее" Тогда
			Если КтоМы = "Поставщик" Тогда
				
				СтандартнаяОбработка=Ложь;
				
				Сообщить("Открытие списка выбора в разработке");
		//переделать на выбор из списка ТД		
				
		
		
		//в ОФ было так:
		//ФормаВыбора = ПолучитьФорму("ТочкиДоставкиСторонние_СписокУправляемая", ,Новый УникальныйИдентификатор());
		//ФормаВыбора.РежимВыбораСписка	= Истина;
		//ФормаВыбора.ВладелецВыбора		= Владелец;
		//Если ФормаВыбора.ОткрытьМодально() = Истина Тогда
		//	ПолеФормы = ФормаВыбора.СсылкаВыбора;
		//КонецЕсли;

		
		//Нужно переделать на выбор из формы выбора ТД, но такой формы пока нет - надо делать   //рефакторинг
			//Если Параметры.МодальностьЗапрещена Тогда 
			//	Выполнить("ОткрытьФормуОбъектаМодально(ПутьКФормам + ""ТочкиДоставкиСторонние_СписокУправляемая"", ПараметрыФормы,""ОбработчикПослеИнтерактивнойНастройкиСоответствий"")");//,ДополнительныеПараметры);
			//Иначе
			//	ВыбраннаяТочкаДоставки = ПолучитьФормуОбработки("ТочкиДоставкиСторонние_СписокУправляемая",ПараметрыФормы).ОткрытьМодально();
			//	ОбработчикПослеИнтерактивнойНастройкиСоответствий("", "")
			//КонецЕсли;
		
		
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьФормуОбработки(ИмяФормы, ПараметрыФормы = Неопределено , ВладелецФормы  = Неопределено, КлючУникальности = Неопределено, ЗакрыватьПризакрытииВладельца = Ложь)
	
	ПолучаемаяФорма=	ПолучитьФорму(ПутьКФормам+ИмяФормы
										, ПараметрыФормы
										,
										, КлючУникальности);
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		ПолучаемаяФорма.ВладелецФормы=	ВладелецФормы;
	КонецЕсли;
	
	Возврат ПолучаемаяФорма;
	
КонецФункции

&НаКлиенте
Процедура ЮрФизЛицо1СОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ЮрФизЛицо1С) Тогда
		
		Если ИмяПоляСообщения = "Грузополучатель" Тогда
			Если Сообщение.Направление = "Входящее" Тогда
				Если КтоМы = "Поставщик" Тогда
					
					ПараметрыФормы = Новый Структура;
					ПараметрыФормы.Вставить("СсылкаТочкиДоставки", ЮрФизЛицо1С);
					Если Параметры.МодальностьЗапрещена Тогда 
						Выполнить("ОткрытьФормуОбъектаМодально(ПутьКФормам + ""ТочкиДоставкиСторонние_ЭлементУправляемая"", ПараметрыФормы)");//,ДополнительныеПараметры);
					Иначе
						ПолучитьФормуОбработки("ТочкиДоставкиСторонние_ЭлементУправляемая",ПараметрыФормы,ЭтаФорма).ОткрытьМодально();
					КонецЕсли;
					
					Возврат;
					
				КонецЕсли;				
			КонецЕсли;
		КонецЕсли;
		
		//открыть модально с обработчиком, который ниже
		
		Если Параметры.МодальностьЗапрещена Тогда
			Выполнить("ПоказатьЗначение(новый ОписаниеОповещения(""ОбработчикПросмотраЗначенияЮрФизЛица1С"",ЭтаФорма),ЮрФизЛицо1С)");
		Иначе

			ИмяОткрываемойФормы="Справочник."+СтроковоеИмяМетаданныхСсылки(ЮрФизЛицо1С)+".ФормаОбъекта";
			ПолучитьФорму(ИмяОткрываемойФормы, Новый Структура("Ключ", ЮрФизЛицо1С)).ОткрытьМодально();
			ОбработчикПросмотраЗначенияЮрФизЛица1С();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СтроковоеИмяМетаданныхСсылки(Ссылка)
	Возврат Метаданные.НайтиПоТипу(ТипЗНЧ(Ссылка)).Имя;
КонецФункции


&НаКлиенте
Процедура ОбработчикПросмотраЗначенияЮрФизЛица1С() Экспорт

	ОбновитьПоляЮрФизЛица();

КонецПроцедуры

&НаСервере
Процедура ОбновитьПоляЮрФизЛица()
	
	Если НЕ ЗначениеЗаполнено(ЮрФизЛицо1С) Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеСообщения = МодульОбъекта().ПолучитьМетаданныеСообщения(Сообщение.ТипСообщения,Сообщение.Направление);
	
	НайденноеПоле = МетаданныеСообщения.Найти(ИмяПоляСообщения,"ИмяПоля");
	
	Если НЕ НайденноеПоле = Неопределено Тогда
		
		ТипПоля1С = НайденноеПоле.Тип1С;
		
		ТекGLN = GLN;
		
		ЮрФизЛицо = МодульОбъекта().КонвертироватьЗначение1СвEDI(ЮрФизЛицо1С,ТипПоля1С,"ЮрФизЛицо",Сообщение);
		
		Если НЕ ЗначениеЗаполнено(ЮрФизЛицо.GLN) Тогда
			ЮрФизЛицо.GLN = ТекGLN;
		КонецЕсли;
		
		//только если это исходящее
		Если Сообщение=Неопределено или Сообщение.Направление<>"Входящее" Тогда 
			ЗаполнитьПоляФормы(ЮрФизЛицо);
		КонецЕсли;
		
		мПроверитьПоляЮрФизЛица();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицо1СПриИзменении(Элемент)
	мПроверитьПоляЮрФизЛица();
КонецПроцедуры
