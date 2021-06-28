
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Владелец") Тогда
		
		Владелец = Параметры.Владелец;
		
		Список.ПроизвольныйЗапрос = Истина;
		Список.ТекстЗапроса = "ВЫБРАТЬ
		|	СправочникБоевыеЧасти.Ссылка,
		|	СправочникБоевыеЧасти.ПометкаУдаления,
		|	СправочникБоевыеЧасти.Владелец,
		|	СправочникБоевыеЧасти.Родитель,
		|	СправочникБоевыеЧасти.Код,
		|	СправочникБоевыеЧасти.Наименование,
		|	СправочникБоевыеЧасти.ПолноеНаименование,
		|	СправочникБоевыеЧасти.ДополнительнаяИнформация,
		|	СправочникБоевыеЧасти.Предопределенный,
		|	СправочникБоевыеЧасти.ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.БоевыеЧасти КАК СправочникБоевыеЧасти
		|ГДЕ
		|	СправочникБоевыеЧасти.Владелец = &Владелец";
		
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Владелец);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБоевуюЧасть(Команда)
	
	ПараметрыОткрытия = Новый Структура("Владелец", Владелец);
	
	ОткрытьФорму("Справочник.БоевыеЧасти.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
