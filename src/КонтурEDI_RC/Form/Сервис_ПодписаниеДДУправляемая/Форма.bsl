﻿&НаСервере
Перем ОбработкаОбъект;

//-------------------------------------------------------------------------------------------------
//клиентские переменные ---------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

&НаКлиенте
Перем СоединениеДД;
  
&НаКлиенте
Перем мРабочийКаталог;

&НаКлиенте
Перем HttpКодыВозвратаAPI;

&НаКлиенте
Перем ХранилищеСертификатовКонтурСВ;

//Вспомогательные-сервисные

&НаСервере
Функция МодульОбъекта()

	Если ОбработкаОбъект=Неопределено Тогда
		
		Если Параметры.КэшироватьМодульОбъекта Тогда
			Если Параметры.АдресХранилища<>"" Тогда
				_Структура = ПолучитьИзВременногоХранилища(Параметры.АдресХранилища);
				Если ТипЗнч(_Структура) = Тип("Структура") Тогда
					_Структура.Свойство("ОбработкаОбъект",ОбработкаОбъект);
				КонецЕсли;
			КонецЕсли;
			
			Если ОбработкаОбъект=Неопределено Тогда
				ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
				ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
				Параметры.АдресХранилища = ПоместитьВоВременноеХранилище(Новый Структура("ОбработкаОбъект",ОбработкаОбъект),УникальныйИдентификатор);
				ОбработкаОбъект.IDОсновнойФормы = Параметры.IDОсновнойФормы;
			КонецЕсли;
		Иначе
			ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
			ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
			ОбработкаОбъект.IDОсновнойФормы = Параметры.IDОсновнойФормы;
		КонецЕсли;
		
	КонецЕсли;	
	
	Возврат ОбработкаОбъект;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуОбъектаМодально(ИмяФормы, ПараметрыФормы = Неопределено, ИмяОбработчика = Неопределено, ПараметрыОбработчика = Неопределено, ВладелецОбработчика = Неопределено,РежимБлокирования = Неопределено)
	//отказ от модальности
	Если РежимБлокирования = Неопределено Тогда
		РежимБлокирования=	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если ПараметрыФормы=Неопределено Тогда
		ПараметрыФормы = Новый Структура;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("АдресХранилища",			Параметры.АдресХранилища);
	ПараметрыФормы.Вставить("IDОсновнойФормы",			Параметры.IDОсновнойФормы);
	ПараметрыФормы.Вставить("КэшироватьМодульОбъекта",	Параметры.КэшироватьМодульОбъекта);
	
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

&НаКлиенте
Функция ПолучитьФормуОбработки(ИмяФормы, ПараметрыФормы = Неопределено , ВладелецФормы  = Неопределено, КлючУникальности = Неопределено, ЗакрыватьПризакрытииВладельца = Ложь)
	
	Если ПараметрыФормы=Неопределено Тогда
		ПараметрыФормы = Новый Структура;
	КонецЕсли;
	
	Если ВладелецФормы = Неопределено Тогда
		ВладелецФормы =	ЭтаФорма;
	КонецЕсли;
	
	//дочерняя форма 1 и без параметров
	
	ПолучаемаяФорма=	ПолучитьФорму(ПутьКФормам+ИмяФормы
										, ПараметрыФормы
										, ВладелецФормы
										, КлючУникальности);
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		ПолучаемаяФорма.ВладелецФормы=	ВладелецФормы;
	КонецЕсли;
	
	Возврат ПолучаемаяФорма;
	
КонецФункции

//Инициализация

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ОбъектПараметрыКлиентСервер", Объект.ПараметрыКлиентСервер);
	
	ПутьКФормам = МодульОбъекта().Метаданные().ПолноеИмя() + ".Форма.";
	МодальностьЗапрещена=МодульОбъекта().МодальностьЗапрещена();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Форма не предусмотрена для интерактивного показа пользователю
	
	ПодписатьПереданныеСообщения();
	//Если эта форма открывается, то для подписи СЧФ //на случай если ошиблись	
	Этаформа.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьПереданныеСообщения() Экспорт //переданные в ВХ 
	
	СформироватьСчетаФактурыНаПодписание();
	
	СпроситьНедостающиеСертификатыДляПодписиИПодписатьСчетаФактуры();
	
	УстановитьНовыеИдентификаторыСчетовФактурИТребуемоеДействие();
	
КонецПроцедуры


//Вспомогательные
&НаСервере
Процедура СформироватьСчетаФактурыНаПодписание()
	
	//соберем идентификаторы СФ которые будем подписывать
	СчетаФактурыНаПодписание.Загрузить(МодульОбъекта().ПолучитьТаблицуСчетовФактурНаПодписание(МодульОбъекта().ИзвлечьИзВХ("МассивСообщений")));
	ЗаполнитьОтпечаткиПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура СпроситьНедостающиеСертификатыДляПодписиИПодписатьСчетаФактуры() //возможен неоднократный вызов для простановки сертифткатов
	
	Состояние("Проверяю сертификаты...");
	ТекОрганизация = неопределено;
	Для Каждого СтрокаСЧФ Из СчетаФактурыНаПодписание Цикл // СчетаФактурыНаПодписание отсортированы по Организации в методе ПолучитьТаблицуСчетовФактурНаПодписание
		Если ТекОрганизация<>СтрокаСЧФ.Организация Тогда 
			ТекОрганизация=СтрокаСЧФ.Организация;
			Если 	  НЕ СертификатПоОрганизацииНазначен(ТекОрганизация) 
					И НЕ ПропускПодписиПоОрганизации(ТекОрганизация) Тогда 
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("ОбъектПараметрыКлиентСервер", Объект.ПараметрыКлиентСервер);
				ПараметрыФормы.Вставить("Организация", ТекОрганизация);
				
				Если МодальностьЗапрещена Тогда 
					Выполнить("ОткрытьФормуОбъектаМодально(ПутьКФормам+""Сертификаты_СписокУправляемая"",ПараметрыФормы,""ВыборНедостающегоСертификата"",ТекОрганизация,ЭтаФорма)");
				Иначе
					ВыбранноеЗначение=ПолучитьФормуОбработки("Сертификаты_СписокУправляемая",ПараметрыФормы,ЭтаФорма).ОткрытьМодально();
					ВыборНедостающегоСертификата(ВыбранноеЗначение, ТекОрганизация);
				КонецЕсли;
				
				Возврат; //не готовы подписывать, сначала надо выбрать сертификат
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	//Все сертификаты выбраны (или не выбраны, если пользователь отказался выбирать)
	
	ПодписатьСчетаФактуры();	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборНедостающегоСертификата(ВыбранноеЗначение,Организация) Экспорт
	
	Если ВыбранноеЗначение=Неопределено Тогда
		
		НайденныеСТроки=СписокНазначенныхСертификатов.НайтиСтроки(Новый Структура("Организация",Организация));
		Если НайденныеСТроки.Количество()=1 Тогда 
			 НайденныеСТроки[0].ПропускПодписи=Истина;
		КонецЕсли;
		
	Иначе
		//Проставим в назначенные
		НайденныеСТроки=СписокНазначенныхСертификатов.НайтиСтроки(Новый Структура("Организация",Организация));
		Если НайденныеСТроки.Количество()>=1 Тогда 
			НайденныеСТроки[0].Отпечаток= ВыбранноеЗначение.Отпечаток;
		Иначе
			//видимо добавим
			НовоеНазначение=СписокНазначенныхСертификатов.Добавить();
			НовоеНазначение.Организация = Организация;
			НовоеНазначение.Отпечаток 	= ВыбранноеЗначение.Отпечаток;
		КонецЕсли;
	КонецЕсли;
	
	СпроситьНедостающиеСертификатыДляПодписиИПодписатьСчетаФактуры();
	
КонецПроцедуры

&НаКлиенте
Функция СертификатПоОрганизацииНазначен(Организация) //мог быть назначен умолчанием или пользователем
	
	НайденныеСТроки=СписокНазначенныхСертификатов.НайтиСтроки(Новый Структура("Организация",Организация));
	Если НайденныеСТроки.Количество()=1
		И ЗначениеЗаполнено(НайденныеСТроки[0].Отпечаток) Тогда 
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции

&НаКлиенте
Функция ПолучитьНазначенныйОрганизацииСертификат(Организация)
	
	НайденныеСТроки=СписокНазначенныхСертификатов.НайтиСтроки(Новый Структура("Организация",Организация));
	Если НайденныеСТроки.Количество()=1
		И ЗначениеЗаполнено(НайденныеСТроки[0].Отпечаток) Тогда 
		Возврат НайденныеСТроки[0].Отпечаток;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ПропускПодписиПоОрганизации(Организация)
	
	НайденныеСТроки=СписокНазначенныхСертификатов.НайтиСтроки(Новый Структура("Организация",Организация));
	Если НайденныеСТроки.Количество()=1
		И НайденныеСТроки[0].ПропускПодписи Тогда 
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьОтпечаткиПоУмолчанию() //выбранные в качестве умолчаний
	
	СписокНазначенныхСертификатов.Очистить();
	СертификатыПоУмолчанию=МодульОбъекта().СертификатыПоУмолчанию();
	
	Для Каждого СертПоУмолчанию Из СертификатыПоУмолчанию Цикл
		НоваяСтрока = СписокНазначенныхСертификатов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СертПоУмолчанию);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНовыеИдентификаторыСчетовФактурИТребуемоеДействие()
	//В общем случае будут присутствовать не все идентификаторы
	//Могут быть БезНДС ники, у них есть только ТОРГ12.
	//Может быть УПД.
	
	СменитьСтатусСообщенияНаПодписанВДиадок=Ложь;
	
	Для каждого ПодписаннаяСчетФактура Из СчетаФактурыНаПодписание Цикл
		
		Если ЗначениеЗаполнено(ПодписаннаяСчетФактура.messageId_new) Тогда 
			МодульОбъекта().УстановитьЗначениеСвойстваОбъекта(ПодписаннаяСчетФактура.Ссылка.Документ,"messageId",ПодписаннаяСчетФактура.messageId_new);	
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПодписаннаяСчетФактура.torg12Id_new) Тогда 
			МодульОбъекта().УстановитьЗначениеСвойстваОбъекта(ПодписаннаяСчетФактура.Ссылка.Документ,"torg12Id",ПодписаннаяСчетФактура.torg12Id_new);	
			СменитьСтатусСообщенияНаПодписанВДиадок=Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПодписаннаяСчетФактура.invoiceId_new) Тогда 
			МодульОбъекта().УстановитьЗначениеСвойстваОбъекта(ПодписаннаяСчетФактура.Ссылка.Документ,"invoiceId",ПодписаннаяСчетФактура.invoiceId_new);	
			СменитьСтатусСообщенияНаПодписанВДиадок=Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПодписаннаяСчетФактура.UniversalTransferDocumentId_new) Тогда 
			МодульОбъекта().УстановитьЗначениеСвойстваОбъекта(ПодписаннаяСчетФактура.Ссылка.Документ,"UniversalTransferDocumentId",ПодписаннаяСчетФактура.UniversalTransferDocumentId_new);	
			СменитьСтатусСообщенияНаПодписанВДиадок=Истина;
		КонецЕсли;
		
		Если СменитьСтатусСообщенияНаПодписанВДиадок Тогда 
			МодульОбъекта().УстановитьСтатусСообщения(ПодписаннаяСчетФактура.Ссылка,  , "INVOIC", "ИсходящийПодписанВДиадок");
		КонецЕсли;
		
	КонецЦикла; 	
	
КонецПроцедуры // УстановитьНовыеИдентификаторыСчетовФактур()

//Прикладные

&НаКлиенте
Процедура ПодписатьСчетаФактуры()
	
	мРабочийКаталог=КаталогВременныхФайлов();
	Состояние("Начинаю подписывать...");
	Прогресс=0;
	Всего=СчетаФактурыНаПодписание.Количество();
	Для Каждого СчетФактураКПодписи Из СчетаФактурыНаПодписание Цикл
		
		Прогресс=Прогресс+1;
		Состояние("Продолжаю подписывать... "+Прогресс+"/"+Всего);
		
		Если НЕ СертификатПоОрганизацииНазначен(СчетФактураКПодписи.Организация) Тогда 
			Продолжить; //по какой-то причине не удалось выбрать сертификат
		КонецЕсли;
		
		ДанныеАвторизации = Новый Структура("Организация,ТипАвторизации,Отпечаток,Расположение",СчетФактураКПодписи.Организация,"Сертификат",ПолучитьНазначенныйОрганизацииСертификат(СчетФактураКПодписи.Организация),"клиент");
		//
		
		MessageЧерновик = ПолучитьMessage(СчетФактураКПодписи.BoxId,СчетФактураКПодписи.MessageId,ДанныеАвторизации);
		
		Если MessageЧерновик.Успешно = Ложь Тогда
			СП=Новый СообщениеПользователю;
			СП.ИдентификаторНазначения=Параметры.IDОсновнойФормы;
			СП.Текст=MessageЧерновик.Значение;
			СП.Сообщить();
			Возврат;
		КонецЕсли;
		
		MessagePatchToPost = Новый Структура;  //это итоговая структура, которую будем отправлять
		MessagePatchToPost.Вставить("BoxId", 		СчетФактураКПодписи.BoxId);
		MessagePatchToPost.Вставить("DraftId", 	СчетФактураКПодписи.MessageId);
		
		////
		МассивСтруктур = Новый Массив;   
		//это нужно будет добавить в MessagePatchToPost   как DocumentSignatures (ниже)
		// в ней будут все подписанные attachement от этого сообщения
										 
		Для Каждого  EntityЧерновика Из MessageЧерновик.Значение.Entities Цикл
			Если EntityЧерновика.EntityType="Attachment" и Значениезаполнено(EntityЧерновика.EntityId) Тогда
				ПодписатьEntity(EntityЧерновика.EntityId,СчетФактураКПодписи,МассивСтруктур);
			КонецЕсли;
		КонецЦикла;
		
		MessagePatchToPost.Вставить("DocumentSignatures", 	МассивСтруктур);
		
		//Отправка
		Если МассивСтруктур.Количество()>0 Тогда 
			Результат=ОтправитьSendDraft(MessagePatchToPost,ДанныеАвторизации);  //sendDraft - очень похож на патч.
			
			//Отражение результатов - укажем в нашей табличке новые идентификаторы
			Если Результат<>Неопределено Тогда 
				Если ТипЗнч(Результат)=Тип("Структура") Тогда 
					СчетФактураКПодписи.MessageId_new=Результат.MessageId;
					//теперь найти invoiceID, torg12Id, updID
					Если ТипЗнч(Результат.Entities)=Тип("Массив")
						И Результат.Entities.Количество()>0 Тогда 
						Для Каждого Entity из Результат.Entities Цикл
							Если Entity.AttachmentType="Invoice" Тогда 
								СчетФактураКПодписи.InvoiceId_new = Entity.EntityId;
							ИначеЕсли Entity.AttachmentType="XmlTorg12" Тогда 
								СчетФактураКПодписи.torg12Id_new = Entity.EntityId;
							ИначеЕсли Entity.AttachmentType="UniversalTransferDocument" Тогда 
								СчетФактураКПодписи.UniversalTransferDocumentId_new = Entity.EntityId;     //УПД
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	
	КонецЦикла;
	
	Состояние("Подписаны. Отражаю результат в системе");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьEntity(EntityId,СчетФактураКПодписи,МассивСтруктур)
	
	ПутьКФайлу1=мРабочийКаталог+EntityId;
	ВременныйФайл1 = Новый Файл(ПутьКФайлу1);
	Если ВременныйФайл1.Существует() Тогда
		УдалитьФайлы(ВременныйФайл1.ПолноеИмя);//Если такой файл уже есть в temp, значит, он остался от предыдущей сессии, когда чо-то пошло не так. Удалим его.
	КонецЕсли;
	
	СохранитьКонтентВложения(СчетФактураКПодписи.BoxId, СчетФактураКПодписи.MessageId, EntityId, ДанныеАвторизации, ПутьКФайлу1);
	
	Signature1 = ПолучитьПодписьФайлаДокумента(ПутьКФайлу1,ДанныеАвторизации);//строка подписи
	
	DocumentSignature = Новый Структура;
	DocumentSignature.Вставить("ParentEntityId", 	EntityId);
	DocumentSignature.Вставить("Signature",			Signature1);
	МассивСтруктур.Добавить(DocumentSignature);
	
КонецПроцедуры // ПодписатьEntity()

&НаКлиенте
Функция ОтправитьSendDraft(MessagePatchToPost,ДанныеАвторизации)
	
	Результат = SendDraft(ЗаписатьJSONВызовСервера(MessagePatchToPost),"",ДанныеАвторизации);
	
	Если Не Результат.Успешно Тогда
		Возврат Неопределено;
		СП=Новый СообщениеПользователю;
		СП.ИдентификаторНазначения=Параметры.IDОсновнойФормы;
		СП.Текст=Результат.ОписаниеОшибки;
		СП.Сообщить();
	КонецЕсли;
	
	Возврат Результат.Значение;		
	
КонецФункции

&НаСервере
Функция ЗаписатьJSONВызовСервера(СтруктураВjson)
	
	Возврат МодульОбъекта().ЗаписатьJSON_(СтруктураВjson);	

КонецФункции

&НаКлиенте
Функция ПолучитьMessage(BoxId,MessageId,ДанныеАвторизации)
	
	Возврат GetMessage(BoxId, MessageId, , , ДанныеАвторизации);								
	
КонецФункции

&НаКлиенте
Функция GetMessage(BoxId, messageId, entityId = Неопределено, originalSignature = Неопределено, ДанныеАвторизации)
	
	ПараметрыСтрокиЗапроса = "BoxId="+BoxId+"&messageId="+messageId;
	Если Не entityId = Неопределено Тогда
		ПараметрыСтрокиЗапроса = ПараметрыСтрокиЗапроса + "&entityId="+entityId;	
	КонецЕсли;
	Если Не originalSignature = Неопределено Тогда
		ПараметрыСтрокиЗапроса = ПараметрыСтрокиЗапроса + "&originalSignature="+originalSignature;	
	КонецЕсли;
	ТипыДанных = Новый Структура("ТипТелаЗапроса,ТипТелаОтвета", "Строка", "Строка");
	
	Результат = ВызватьМетодAPI("/V3/GetMessage",ПараметрыСтрокиЗапроса,"GET","","",ДанныеАвторизации,ТипыДанных);
	Если Не Результат.Успешно Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.Значение = DoParseВызовСервера(Результат.Значение);
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция SendDraft(RequestBody, operationId="", ДанныеАвторизации)     //аналог PostMessagePatch для черновиков
	
	ПараметрыСтрокиЗапроса = "";
	Если Не ПустаяСтрока(operationId) Тогда
		ПараметрыСтрокиЗапроса = ПараметрыСтрокиЗапроса + "operationId="+operationId;
	КонецЕсли;
	ТипыДанных = Новый Структура("ТипТелаЗапроса,ТипТелаОтвета","Строка","Строка");
	
	Результат = ВызватьМетодAPI("/SendDraft",ПараметрыСтрокиЗапроса,"POST","",RequestBody, ДанныеАвторизации, ТипыДанных);
	
	Результат.Значение = DoParseВызовСервера(Результат.Значение);
	Возврат Результат;	
	
КонецФункции

&НаСервере
Функция DoParseВызовСервера(Строка)
	Возврат МодульОбъекта().DoParse(Строка);
КонецФункции

&НаКлиенте
Функция ПолучитьПодписьФайлаДокумента(ПутьКФайлу,ДанныеАвторизации)
	
	//серверный аналог функции расположен в модуле объекта
	
	Попытка
	
		Скрипт = Новый COMОбъект("MSScriptControl.ScriptControl");
		Скрипт.language = "vbscript";
		
		Сертификат = ПолучитьСертификат(ДанныеАвторизации.Отпечаток,3);
		
		ТекстСкрипта = "
		|Const FileTypeBinary = 1
		|
		|Function SignFile(SourceFile)
		|
		|	Set objStream = CreateObject(""ADODB.Stream"")
		|	With objStream
		|		.Type = FileTypeBinary
		|		.Open
		|		.LoadFromFile SourceFile
		|	End With
		|	dataToSign = objStream.Read
		|	Set oSigner = CreateObject(""CAPICOM.Signer"")
		|	oSigner.Certificate = certificate
		|	oSigner.Options = 2
		|	Set oSignedData = CreateObject(""CAPICOM.SignedData"")
		|	oSignedData.Content = dataToSign
		|	sSignedMessage = oSignedData.Sign(oSigner, true)
		|
		|	SignFile = sSignedMessage
		|End Function
		|";
		
		Скрипт.AddObject("certificate", Сертификат);
		Скрипт.AddCode(ТекстСкрипта);
		
		ШифрованнаяПодпись = Скрипт.CodeObject.SignFile(ПутьКФайлу);
		ШифрованнаяПодпись = Лев(ШифрованнаяПодпись,СтрДлина(ШифрованнаяПодпись)-2);
		
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ШифрованнаяПодпись;
	
КонецФункции

&НаКлиенте
Функция СохранитьКонтентВложения(BoxId, MessageId, EntityId, ДанныеАвторизации, ПутьКФайлу)
	
	Результат = ИнициализироватьСтруктуруРезультатаФункции();
	
	РезультатGetEntityContent = GetEntityContent(BoxId, MessageId, EntityId, ДанныеАвторизации);
	Если Не РезультатGetEntityContent.Успешно Тогда
		Результат.ОписаниеОшибки = РезультатGetEntityContent.ОписаниеОшибки;
		Возврат Результат;
 	КонецЕсли;
	EntityContent = РезультатGetEntityContent.Значение;
	
	COMSafeArrayToFile(EntityContent,ПутьКФайлу);
	
	ФайлКонтентаВложения = Новый Файл(ПутьКФайлу);
	Если Не ФайлКонтентаВложения.Существует() Тогда
		Результат.ОписаниеОшибки = "не удалось сохранить файл на диск";
		Возврат Результат;			
	КонецЕсли;
		
	Результат.Успешно = Истина;
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция GetEntityContent(BoxId, MessageId, EntityId, ДанныеАвторизации)
			
	ПараметрыСтрокиЗапроса = "boxId="+BoxId + "&messageId="+MessageId + "&entityId="+EntityId;
	ТипыДанных 	= Новый Структура("ТипТелаЗапроса,ТипТелаОтвета", "Строка", "ДвоичныеДанные");
	
	Возврат ВызватьМетодAPI("/V4/GetEntityContent",ПараметрыСтрокиЗапроса,"GET","","", ДанныеАвторизации, ТипыДанных);
			
КонецФункции

&НаКлиенте
Функция COMSafeArrayToFile(ComSafeArray,ПутьКФайлу)
	
	Попытка	
	    StreamOut = Новый COMОбъект("ADODB.Stream");
		StreamOut.Type = 1; //двоичные данные (2-текстовые данные)
		StreamOut.Mode = 3; //чтение/запись
		StreamOut.Open();
		StreamOut.Write(ComSafeArray); 
		StreamOut.SaveToFile(ПутьКФайлу, 2);
		StreamOut.Close();
	Исключение
	КонецПопытки;
	
КонецФункции

&НаКлиенте
Функция ИнициализироватьСтруктуруРезультатаФункции()
	
	СтруктураРезультата = Новый Структура();
	
	СтруктураРезультата.Вставить("Успешно",			Ложь);
	СтруктураРезультата.Вставить("ОписаниеОшибки",	"");
	
	Возврат СтруктураРезультата;
	
КонецФункции

Функция ЗначениеСоответствуетТипу(Значение,СтрокаТип)
	
	Возврат ТипЗнч(Значение) = Тип(СтрокаТип);
	 	
КонецФункции

&НаКлиенте
Функция ВызватьМетодAPI(ИмяРесурса, ПараметрыСтрокиЗапроса="", Метод, УчетнаяЗапись, ТелоЗапроса="", ДанныеАвторизации, ТипыДанных)
		
	Результат = Новый Структура("Успешно,Значение,ОписаниеОшибки",Ложь,Неопределено,"");
	
	//работаем через COM-объект Mictosoft.XMLHTTP, а значит через IE, который кэширует запросы по АдресуЗапроса
	//для исключения кэширования к АдресуЗапроса добавляем параметр ParamPresentTime, содержащим текущее время с точностью до секунд
	ПараметрыСтрокиЗапроса = ПараметрыСтрокиЗапроса + ?(ПараметрыСтрокиЗапроса="","","&")+"presentTime="+Формат(ТекущаяДата(),"ДФ=yyyyMMddHHmmss");
	
	ИмяФайлаОтвета = ПолучитьИмяВременногоФайла();			
	
	Для НомерПопытки = 1 По 2 Цикл //после первой попытки можем переподключиться
		
		Токен = Токен(ДанныеАвторизации);
		Если Токен = Неопределено и ДанныеАвторизации.Расположение = "клиент" Тогда
			Результат.ОписаниеОшибки = "отсутсвует авторизация по клиентскому сертификату";
			Возврат Результат;					
		КонецЕсли;
		
		HttpЗаголовки = Новый Соответствие;
		HttpЗаголовки.Вставить("Authorization","DiadocAuth ddauth_api_client_id="+КлючАвторизацииAPI()+",ddauth_token="+Токен);
		HttpЗаголовки.Вставить("Accept","application/json");//без этого вернется протобуфер
		HttpЗаголовки.Вставить("Content-Type","application/json; charset=utf-8");//для отправки в JSON вместо protobuf
		
		Попытка
			РезультатВыполнения = ВыполнитьЗапросAPI(СоединениеДД(),ИмяРесурса,ПараметрыСтрокиЗапроса,HttpЗаголовки,Метод,ТелоЗапроса,ТипыДанных);
 		Исключение
			_ОписаниеОшибки = ОписаниеОшибки();
		КонецПопытки;
		
		Если РезультатВыполнения = Неопределено Тогда
			Продолжить;
		ИначеЕсли РезультатВыполнения.Успешно Тогда
			ЗаполнитьЗначенияСвойств(Результат,РезультатВыполнения);
			Прервать;
		ИначеЕсли Не РезультатВыполнения.Успешно Тогда
			ЗаполнитьЗначенияСвойств(Результат,РезультатВыполнения);
			Если НомерПопытки = 1 Тогда
				ОшибкаАвторизации = ОшибкаАвторизацииПоHttpКодуВозврата(ИмяРесурса,РезультатВыполнения.HttpКодВозврата);
				Если ОшибкаАвторизации Тогда
				    Токен(ДанныеАвторизации,Ложь);
				КонецЕсли;
			Иначе
				ЗарегистрироватьОшибкуАвторизации(ДанныеАвторизации.Организация,РезультатВыполнения.ОписаниеОшибки);
			КонецЕсли;
		КонецЕсли;		
		
	КонецЦикла;
		
	Возврат Результат;	
	
КонецФункции

//Проверим что можем получить реквизиты серта и что с ним нам удастся авторизоваться
&НаКлиенте
Процедура ПроверитьВыбранныйСертификат(ДанныеАвторизации)
	
	Если ДанныеАвторизации.Расположение = "клиент" Тогда
		
		РеквизитыСертификата = ПолучитьРеквизитыСертификата(ДанныеАвторизации.Отпечаток);
		Если РеквизитыСертификата = Неопределено Тогда
			Сообщить("Выбранный сертификат не найден.");
			Возврат;			
		КонецЕсли;
		
		Токен = МодульОбменКлиент().Токен(ДанныеАвторизации);
		Если Токен = Неопределено Тогда
			Сообщить("Не удалось авторизоваться по выбранному сертификату");
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	//Если Не ЗначениеЗаполнено(Реквизит_LastEventId) Тогда
	//	Реквизит_LastEventId = ТекущаяДата();	
	//КонецЕсли;                               	
	
КонецПроцедуры
//заполнение

//-------------------------------------------------------------------------------------------------
//обработка выполнения http-запросов  -------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

&НаКлиенте
Процедура ЗарегистрироватьОшибкуАвторизации(Организация,ОписаниеОшибки)

	//получить токен, повторно авторизовавшись

КонецПроцедуры // ЗарегистрироватьОшибкуАвторизации()

&НаКлиенте
Функция ОшибкаАвторизацииПоHttpКодуВозврата(ИмяРесурса,HttpКодВозврата)
	
	ОшибкаАвторизации = Ложь;
	Возврат "401"=HttpКодВозврата;
	
	//// по хорошему надо так:
	ПодготовитьТаблицуHttpКодовВозврата();
			
	Отбор = Новый Структура("ИмяРесурса,HttpКодВозврата",ИмяРесурса,HttpКодВозврата);
	МассивСтрок = HttpКодыВозвратаAPI.НайтиСтроки(Отбор);
	Если Не МассивСтрок.Количество() = 0 Тогда
		Строка = МассивСтрок[0];
		ОшибкаАвторизации = Строка.ОшибкаАвторизации;
	КонецЕсли;
	 
	Возврат ОшибкаАвторизации;
			
КонецФункции

&НаКлиенте
Процедура ДобавитьДанныеHttpКодаВозврата(Массив,ИмяРесурса,HttpКодВозврата,ОшибкаАвторизации,Описание)
	
	Данные = Новый Структура;
	Данные.Вставить("ИмяРесурса",		ИмяРесурса);
	Данные.Вставить("HttpКодВозврата",	HttpКодВозврата);
	Данные.Вставить("ОшибкаАвторизации",ОшибкаАвторизации);
	Данные.Вставить("Описание",			Описание);
	
	Массив.Добавить(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьТаблицуHttpКодовВозврата()
	
	Если Не HttpКодыВозвратаAPI = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	HttpКодыВозвратаAPI = Новый Массив;
	ДобавитьДанныеHttpКодаВозврата(HttpКодыВозвратаAPI,"/Authenticate",	200,Ложь,  "операция успешно завершена");
	ДобавитьДанныеHttpКодаВозврата(HttpКодыВозвратаAPI,"/Authenticate",	400,Ложь,  "данные в запросе имеют неверный формат или отсутствуют обязательные параметры");
	ДобавитьДанныеHttpКодаВозврата(HttpКодыВозвратаAPI,"/Authenticate",	401,Истина,"в запросе отсутствует HTTP-заголовок Authorization, или в этом заголовке отсутствует параметр ddauth_api_client_id, или переданный в нем ключ разработчика не зарегистрирован в Диадоке");
	ДобавитьДанныеHttpКодаВозврата(HttpКодыВозвратаAPI,"/SendDraft",	403,Ложь,  "У вас нет права подписи в организации");
	ДобавитьДанныеHttpКодаВозврата(HttpКодыВозвратаAPI,"/Authenticate",	405,Ложь,  "используется неподходящий HTTP-метод");
	ДобавитьДанныеHttpКодаВозврата(HttpКодыВозвратаAPI,"/Authenticate",	500,Ложь,  "при обработке запроса возникла непредвиденная ошибка");
		
КонецПроцедуры

&НаКлиенте
Функция ОписаниеHttpКодаВозврата(ИмяРесурса,HttpКодВозврата)
	
	Описание = "";
	СтруктураHttpКодаВозврата = Неопределено;
	
	ПодготовитьТаблицуHttpКодовВозврата();
	
	Для Каждого Структура Из HttpКодыВозвратаAPI Цикл
		Если Не Структура.ИмяРесурса = ИмяРесурса или
			 Не Структура.HttpКодВозврата = HttpКодВозврата Тогда
			Продолжить;			
		КонецЕсли;
		СтруктураHttpКодаВозврата = Структура;
	КонецЦикла;
	
	Если Не СтруктураHttpКодаВозврата = Неопределено Тогда
		Описание = СтруктураHttpКодаВозврата.Описание;
	КонецЕсли;
	
	Возврат Описание;
	
КонецФункции
  
//-------------------------------------------------------------------------------------------------
//авторизация на сервере Диадока ------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

&НаКлиенте
Функция КлючАвторизацииAPI()
	
	Возврат "1S-Box2_19-b9b4602d-c9fa-4680-ad9a-0bd740eed1c8";
		
КонецФункции

&НаКлиенте
Функция ШаблонДанныхАвторизации()
	
	Структура = Новый Структура;
	
	Структура.Вставить("Организация");
	Структура.Вставить("ТипАвторизации");
	Структура.Вставить("Логин");
	Структура.Вставить("Пароль");
	Структура.Вставить("Отпечаток");
	Структура.Вставить("Расположение");
		
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Функция ВыполнитьЗапросAPI(Соединение, ИмяРесурса, ПараметрыСтрокиЗапроса="" ,HttpЗаголовки, Метод, ТелоЗапроса="", ТипыДанных)
	
	Результат = Новый Структура("Успешно,Значение,HttpКодВозврата,ОписаниеОшибки",Ложь,Неопределено,500,"");
	
	ПолныйАдрес = ИмяРесурса + ?(ПараметрыСтрокиЗапроса="","","?") + ПараметрыСтрокиЗапроса;
	
	ТипТелаЗапроса = ТипыДанных.ТипТелаЗапроса;
	ТипТелаОтвета = ТипыДанных.ТипТелаОтвета;
	
	АдресАпи = "https://diadoc-api.kontur.ru";
			    		
	Соединение.Open(Метод,АдресАпи+ПолныйАдрес,0);

	Для Каждого HttpЗаголовок Из HttpЗаголовки Цикл
		Соединение.SetRequestHeader(HttpЗаголовок.Ключ, HttpЗаголовок.Значение);
	КонецЦикла;
	
	Если ТипТелаЗапроса = "ПутьКФайлу" Тогда
		Соединение.Send(BinaryStream(ТелоЗапроса));
	ИначеЕсли ТипТелаЗапроса = "Строка" Тогда
		Соединение.Send(ТелоЗапроса);		
	КонецЕсли;
	
	HttpКодВозврата = Соединение.status;
	Если ТипТелаОтвета = "ДвоичныеДанные" Тогда               
		Значение = Соединение.ResponseBody;
	ИначеЕсли ТипТелаОтвета = "Строка" Тогда
		Значение = Соединение.ResponseText();
	КонецЕсли;
	
	Результат.Успешно = (HttpКодВозврата = 200);
	Результат.Значение = Значение;
	Результат.HttpКодВозврата = HttpКодВозврата;
	Результат.ОписаниеОшибки = ОписаниеHttpКодаВозврата(ИмяРесурса,HttpКодВозврата);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция Токен(ДанныеАвторизации, ИспользоватьКэш=Истина) Экспорт
	
	Токен = Неопределено;
	
	Если ДанныеАвторизации.ТипАвторизации = "ЛогинПароль" Тогда
		Ключ = ДанныеАвторизации.Логин;		
	ИначеЕсли ДанныеАвторизации.ТипАвторизации = "Сертификат" Тогда
		Ключ = ДанныеАвторизации.Отпечаток;	
	КонецЕсли;
	
	Если ИспользоватьКэш Тогда	
		Токены = ИзвлечьИзВХ("Токены"); //это соответствие: "отпечаток-токен" или "логин-токен"
		Если Не Токены = Неопределено Тогда
			Токен = Токены.Получить(Ключ);
		КонецЕсли;
	КонецЕсли;
		
	Если Токен = Неопределено Тогда
		
		Токен					= "";
		ПараметрыСтрокиЗапроса	= "";
		ТелоЗапроса 			= "";
		ИмяРесурса				= "/Authenticate";
		Если ДанныеАвторизации.ТипАвторизации = "ЛогинПароль" Тогда //авторизация по логину/паролю
			ПараметрыСтрокиЗапроса = "login=" + ДанныеАвторизации.Логин + "&password=" + ДанныеАвторизации.Пароль;
			ТипыДанных 	= Новый Структура("ТипТелаЗапроса,ТипТелаОтвета", "Строка", "Строка");
		ИначеЕсли ДанныеАвторизации.ТипАвторизации = "Сертификат" Тогда //авторизация по сертификату
			ТелоЗапроса = ПолучитьСертификат(ДанныеАвторизации.Отпечаток,0);
			ТипыДанных 	= Новый Структура("ТипТелаЗапроса,ТипТелаОтвета", "Строка", "ДвоичныеДанные");
		КонецЕсли;
		HttpЗаголовки = Новый Соответствие;
		HttpЗаголовки.Вставить("Authorization","DiadocAuth ddauth_api_client_id="+КлючАвторизацииAPI());// konturediauth_login="""+УчетнаяЗапись.Логин+""" , konturediauth_password="""+УчетнаяЗапись.Пароль+"""";
						
		Попытка
			РезультатВыполнения = ВыполнитьЗапросAPI(СоединениеДД(), ИмяРесурса, ПараметрыСтрокиЗапроса, HttpЗаголовки, "POST", ТелоЗапроса, ТипыДанных);
		Исключение
			_ОписаниеОшибки = ОписаниеОшибки();
			Сообщить("Не удалось выполнить запрос " + ИмяРесурса + " на клиенте: " + _ОписаниеОшибки);
			Возврат Неопределено;
		КонецПопытки;
		Если Не РезультатВыполнения.Успешно Тогда
			Сообщить("Запрос " + ИмяРесурса + " выполнен на клиенте с ошибкой: " + РезультатВыполнения.ОписаниеОшибки);
			Возврат Неопределено;		
		КонецЕсли;
				
		Если ТипыДанных.ТипТелаОтвета = "ДвоичныеДанные" Тогда 
			Токен = РасшифроватьЗашифрованныйТокен(РезультатВыполнения.Значение); //расшифруем ответ сервера закрытым ключом из контейнера	
        ИначеЕсли ТипыДанных.ТипТелаОтвета = "Строка" Тогда
			Токен = РезультатВыполнения.Значение;
		КонецЕсли;
		
		Если Токены = Неопределено Тогда
			Токены = ИзвлечьИзВХ("Токены");
		КонецЕсли;
		Если Токены = Неопределено Тогда
			Токены = Новый Соответствие;
		КонецЕсли;
		Токены.Вставить(Ключ,Токен);
		ПоместитьВоВХ("Токены", Токены);
		
	КонецЕсли;
	
	Возврат Токен;
	
КонецФункции


//-------------------------------------------------------------------------------------------------
//криптография ------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

&НаКлиенте
Функция ШаблонРеквизитовСертификата()
	
	Структура = Новый Структура;
	Структура.Вставить("НаименованиеОрганизацииСубъекта","");
	Структура.Вставить("НаименованиеСубъекта","");
	Структура.Вставить("НачалоПериодаДействия",Дата(1,1,1));
	Структура.Вставить("ОкончаниеПериодаДействия",Дата(1,1,1));
	Структура.Вставить("НаименованиеУдостоверяющегоЦентра","");
	Структура.Вставить("Отпечаток","");
	Структура.Вставить("Расположение","клиент"); // отличет от серверного метода
	
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Функция ПолучитьРеквизитыСертификата(Отпечаток) Экспорт
	
	РеквизитыСертификата = Неопределено;	
	
	Попытка 
		
		КоллекцияСертификатовХранилища = ХранилищеСертификатов().Certificates;
		КоличествоСертификатовХранилища = КоллекцияСертификатовХранилища.Count;
		
		Для Индекс = 1 По КоличествоСертификатовХранилища Цикл
			
			Сертификат = КоллекцияСертификатовХранилища.Item(Индекс);
			Если Не Сертификат.Thumbprint = Отпечаток Тогда
				Продолжить;
			КонецЕсли;
			
			РеквизитыСертификата = ПолучитьРеквизитыCOMОбъектаСертификата(Сертификат);
			Прервать;
						
		КонецЦикла;
		
	Исключение
		_ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат РеквизитыСертификата;
	
КонецФункции

&НаКлиенте
Функция МассивСертификатов() Экспорт
	
	МассивСертификатов = Новый Массив;
			
	Попытка 
		
		КоллекцияСертификатовХранилища = ХранилищеСертификатов().Certificates;
		КоличествоСертификатовХранилища = КоллекцияСертификатовХранилища.Count;
		
		Для Индекс = 1 По КоличествоСертификатовХранилища Цикл
			
			Сертификат = КоллекцияСертификатовХранилища.Item(Индекс);
			
			Если Сертификат.ValidToDate() < ТекущаяДата() Тогда
				Продолжить;
			КонецЕсли;
						
			РеквизитыСертификата = ПолучитьРеквизитыCOMОбъектаСертификата(Сертификат);
			МассивСертификатов.Добавить(РеквизитыСертификата);
						
		КонецЦикла;
				
	Исключение
		_ОписаниеОшибки = ОписаниеОшибки();
		Возврат Неопределено;
	КонецПопытки;
		
	Возврат МассивСертификатов;
	
КонецФункции

&НаКлиенте
Функция ПолучитьРеквизитыCOMОбъектаСертификата(COMОбъектСертификата)
	
	РеквизитыСертификата = ШаблонРеквизитовСертификата();
	
	МассивДанныхУЦ = РазложитьСтрокуВМассивСлов_КонтурСВ(COMОбъектСертификата.IssuerName,",");
	Для Каждого Элемент Из МассивДанныхУЦ Цикл
		Если Найти(Элемент,"O=")>0 Тогда 
			НаименованиеУдостоверяющегоЦентра = СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрЗаменить(Элемент,"O=",""),"""""","|"),"""",""),"|","""");
		КонецЕсли;
	КонецЦикла;
	
	НаименованиеСубъекта = "";
	НаименованиеОрганизацииСубъекта = "";
	МассивДанныхСубъекта = РазложитьСтрокуВМассивСлов_КонтурСВ(COMОбъектСертификата.SubjectName,",");
	Для Каждого Элемент Из МассивДанныхСубъекта Цикл
		Если Найти(Элемент,"CN=")>0 Тогда
			НаименованиеСубъекта = СтрЗаменить(Элемент,"CN=",""); 			
		ИначеЕсли Найти(Элемент,"O=")>0 Тогда 
			НаименованиеОрганизацииСубъекта = СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрЗаменить(Элемент,"O=",""),"""""","|"),"""",""),"|","""");
		КонецЕсли;
	КонецЦикла;
	
	РеквизитыСертификата.НаименованиеОрганизацииСубъекта = НаименованиеОрганизацииСубъекта;
	РеквизитыСертификата.НаименованиеСубъекта = НаименованиеСубъекта;
	РеквизитыСертификата.НачалоПериодаДействия = COMОбъектСертификата.ValidFromDate;
	РеквизитыСертификата.ОкончаниеПериодаДействия = COMОбъектСертификата.ValidToDate;
	РеквизитыСертификата.НаименованиеУдостоверяющегоЦентра = НаименованиеУдостоверяющегоЦентра;
	РеквизитыСертификата.Отпечаток = COMОбъектСертификата.Thumbprint;
	
	Возврат РеквизитыСертификата;	
		
КонецФункции

&НаКлиенте
Функция ПолучитьСертификат(Отпечаток, ЭкспортСертификата=0)
	
	Сертификат = Неопределено;
		                          
	Попытка
						
		Если ЭкспортСертификата = 3 Тогда //возвращает сертификат
			Сертификат = ХранилищеСертификатов().Certificates.Find(0, Отпечаток).Item(1); //0 - CAPICOM_CERTIFICATE_FIND_SHA1_HASH
		Иначе //экспорт сертификата 0 - Base64, 1 - DER (двоичные данные)
			Сертификат = ХранилищеСертификатов().Certificates.Find(0, Отпечаток).Item(1).Export(ЭкспортСертификата); //0 - CAPICOM_CERTIFICATE_FIND_SHA1_HASH	
		КонецЕсли;
				
	Исключение
		_ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Сертификат;
	
КонецФункции

&НаКлиенте
Функция РасшифроватьЗашифрованныйТокен(ЗашифрованныйТокен)
	
	Токен = "";
	
	Попытка
	
		Дешифратор = Новый COMОбъект("CAPICOM.EnvelopedData");
		Дешифратор.Decrypt(ЗашифрованныйТокен); //токен будет представлен массивом байт, прогоним его через перекодировщик.
		
		Перекодировщик = Новый COMОбъект("CAPICOM.Utilities");
		ТокенВСтроках = Перекодировщик.Base64Encode(Дешифратор.Content); //получим токен в строках Base64
		
		НомерСтроки = 1; //объединим все строки в одну
		ОчереднаяСтрока = СтрПолучитьСтроку(ТокенВСтроках,НомерСтроки);
		Пока ОчереднаяСтрока<>"" Цикл
			Токен = Токен + ОчереднаяСтрока;
			НомерСтроки = НомерСтроки + 1;
			ОчереднаяСтрока = СтрПолучитьСтроку(ТокенВСтроках,НомерСтроки);
		КонецЦикла;
		
	Исключение
		Токен = Неопределено;
	КонецПопытки;
	
	Возврат Токен;
	
КонецФункции

&НаКлиенте
Функция ХранилищеСертификатов()
	
	Если ТипЗнч(ХранилищеСертификатовКонтурСВ) = Тип("COMОбъект") Тогда
		Возврат ХранилищеСертификатовКонтурСВ;	
	КонецЕсли;
	
	CAPICOM_MY_STORE = "My";
	CAPICOM_CURRENT_USER_STORE = 2;
	CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED = 2;
	CAPICOM_CERTIFICATE_FIND_SHA1_HASH = 0;
	
	Попытка
		ХранилищеСертификатовКонтурСВ = Новый COMОбъект("CAPICOM.Store");
		ХранилищеСертификатовКонтурСВ.Open(CAPICOM_CURRENT_USER_STORE, CAPICOM_MY_STORE, CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);
	Исключение
		_ОписаниеОшибки = ОписаниеОшибки();
		Сообщить("Не удалось инициализировать локальное хранилице сертификатов (" + _ОписаниеОшибки + ").");
	КонецПопытки;
	
	Возврат ХранилищеСертификатовКонтурСВ;	
		
КонецФункции

&НаКлиенте
Функция СоединениеДД()
	
	Если ТипЗнч(СоединениеДД) = Тип("COMОбъект") Тогда
		Возврат СоединениеДД;
	КонецЕсли;
	
	Сервер = "diadoc-api.kontur.ru";
	Прокси = Неопределено;
	Порт = 443;
	ЗащищенноеСоединение = Истина;
	
	СоединениеДД = ПолучитьCOMОбъект("","Microsoft.XMLHTTP");
	
	Возврат СоединениеДД;
		
КонецФункции

//-------------------------------------------------------------------------------------------------
//вспомогательные методы --------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

&НаКлиенте
Функция РазложитьСтрокуВМассивСлов_КонтурСВ(Знач Строка, РазделителиСлов="")
	
	Слова = Новый Массив;
	
	Для Сч = 1 По СтрДлина(РазделителиСлов) Цикл
		Строка = СтрЗаменить(Строка,Сред(РазделителиСлов,Сч,1),Символы.ПС);
	КонецЦикла;
	
	Для Сч=1 По СтрЧислоСтрок(Строка) Цикл
		ТекСлово = СокрЛП(СтрПолучитьСтроку(Строка,Сч));
		Если ТекСлово<>"" Тогда
			Слова.Добавить(ТекСлово);
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат Слова;
	
КонецФункции

&НаКлиенте
Функция BinaryStream(ПутьКФайлу)
	
	Stream = Новый COMОбъект("ADODB.Stream");
    Stream.Type = 1;
    Stream.Open();
	Stream.LoadFromFile(ПутьКФайлу);
	Возврат Stream.Read();
	
КонецФункции

&НаКлиенте
Процедура ПоместитьВоВХ(Имя,Значение)
	
	ПоместитьВоВременноеХранилище(Значение, Объект.ПараметрыКлиентСервер.АдресаВХ[Имя]);
				
КонецПроцедуры

&НаКлиенте
Функция ИзвлечьИзВХ(Имя)
	
	АдресВХ = Объект.ПараметрыКлиентСервер.АдресаВХ[Имя];
	
	Если Не ЭтоАдресВременногоХранилища(АдресВХ) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПолучитьИзВременногоХранилища(АдресВХ);
			
КонецФункции

&НаКлиенте
Функция ОсновнаяФорма() Экспорт
	
	Если ЭтаФорма.ВладелецФормы = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат ЭтаФорма.ВладелецФормы.ОсновнаяФорма();
	КонецЕсли;
    	
КонецФункции

&НаКлиенте
Функция МодульОбменКлиент()
	
	Возврат ЭтаФорма;
	
КонецФункции
