
#Область ОбработчикиСобытийФормы
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Предопределенный Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// Установка значения реквизита АдресКартинки.
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Не Объект.ФлагСтраны.Пустая() Тогда
			АдресКартинки = ПолучитьНавигационнуюСсылкуКартинки(Объект.ФлагСтраны, УникальныйИдентификатор)
		Иначе
			АдресКартинки = "";
		КонецЕсли;
	КонецЕсли;
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Справочник.ОКСМ.Изменение", Объект.Ссылка, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ФлагСтраныПриИзменении(Элемент)
	
	Если Не Объект.ФлагСтраны.Пустая() Тогда
		АдресКартинки = ПолучитьНавигационнуюСсылкуКартинки(Объект.ФлагСтраны, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагСтраныНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыКлиент.ОткрытьФормуВыбораФайлов(Объект.Ссылка, Элементы.ФлагСтраны);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы

КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	ПрисоединенныеФайлыКлиент.ОткрытьФормуВыбораФайлов(Объект.Ссылка, Элементы.ФлагСтраны);
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуКартинки(ФайлКартинки, ИдентификаторФормы)
	
	Попытка
		Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(ФайлКартинки, ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Не ТекущийОбъект.ФлагСтраны.Пустая() Тогда
		АдресКартинки = ПолучитьНавигационнуюСсылкуКартинки(ТекущийОбъект.ФлагСтраны, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыДляКорректировкиСправочников") И КоманднаяПанель.ПодчиненныеЭлементы.ФормаОбщаяКомандаАкцептоватьИзмененияВСправочнике.Видимость Тогда
	
		Отказ = Истина;
		Возврат;
	
	КонецЕсли;
	
	Если СлужебныеФункции.НайтиДубльСправочникаПоНаименованию(ТекущийОбъект.Ссылка, ТекущийОбъект.Наименование) Тогда
		
		Сообщить("В справочнике уже есть элемент с таким наименованием!", СтатусСообщения.Важное);
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОКСМ.Ссылка
	|ИЗ
	|	Справочник.ОКСМ КАК ОКСМ
	|ГДЕ
	|	ОКСМ.БуквенныйКодАльфа3 = &БуквенныйКодАльфа3
	|	И НЕ ОКСМ.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
	Запрос.УстановитьПараметр("БуквенныйКодАльфа3", ТекущийОбъект.БуквенныйКодАльфа3);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
	
		Сообщить("В справочнике уже есть элемент с таким кодом альфа-3!", СтатусСообщения.Важное);
		Отказ = Истина;
		Возврат;	
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
