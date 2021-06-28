
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Владелец") Тогда
	
		Объект.Владелец = Параметры.Владелец;	
	
	КонецЕсли;
	
	ЭтоНовый = Не ЗначениеЗаполнено(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.Родитель) Тогда
	
		ПолноеНаименованиеРодителя = ОбщиеФункцииСервер.ПолучитьЗначениеРеквизита(Объект.Родитель, "ПолноеНаименование");	
	
	КонецЕсли;
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗаписанНовый Тогда
	
		СтандартнаяОбработка = Ложь;
		
		Закрыть(Объект.Ссылка);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ЗаписанНовый = ЭтоНовый;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеРодителяОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Родитель) Тогда
	
		Возврат;	
	
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ключ", Объект.Родитель);
	
	ОткрытьФорму("Справочник.БоевыеЧасти.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеРодителяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("Владелец", Объект.Владелец);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикВыбораРодителя", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.БоевыеЧасти.ФормаВыбора", ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВыбораРодителя(БоеваяЧасть, ДопПараметры = Неопределено) Экспорт

	Если ЗначениеЗаполнено(БоеваяЧасть) Тогда
	
		Объект.Родитель = БоеваяЧасть;
		ПолноеНаименованиеРодителя = ОбщиеФункцииСервер.ПолучитьЗначениеРеквизита(Объект.Родитель, "ПолноеНаименование");
		Модифицированность = Истина;
	
	КонецЕсли;	

КонецПроцедуры // ОбработчикВыбораРодителя()

&НаКлиенте
Процедура ПолноеНаименованиеРодителяОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.Родитель = ПредопределенноеЗначение("Справочник.БоевыеЧасти.ПустаяСсылка");	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыДляКорректировкиСправочников") И КоманднаяПанель.ПодчиненныеЭлементы.ФормаОбщаяКомандаАкцептоватьИзмененияВСправочнике.Видимость Тогда
	
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры
