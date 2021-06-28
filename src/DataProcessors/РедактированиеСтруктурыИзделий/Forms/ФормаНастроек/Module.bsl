
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ЗаполнятьДеревоСпецификацииИзСоставаИзделий", ЗаполнятьДеревоСпецификацииИзСоставаИзделий);
	Параметры.Свойство("ВариантДобавленияЭлементовВСтруктуруКорабля", ВариантДобавленияЭлементовВСтруктуруКорабля);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ЗаполнятьДеревоСпецификацииИзСоставаИзделий", ЗаполнятьДеревоСпецификацииИзСоставаИзделий);
	ПараметрыЗакрытия.Вставить("ВариантДобавленияЭлементовВСтруктуруКорабля", ВариантДобавленияЭлементовВСтруктуруКорабля);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры
