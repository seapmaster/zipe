
Процедура ПриЗаписи(Отказ, Замещение)
	Для Каждого Элемент Из ЭтотОбъект Цикл
		Если ТипЗнч(Элемент.Владелец) = Тип("СправочникСсылка.КаталогПредметовСнабжения") Тогда
			РегистрыСведений.ОчередьОбновленияИндекса.УстановитьОбъектВОчередьОбновленияПоисковогоИндекса(Элемент.Владелец);		
		КонецЕсли;		
	КонецЦикла; 
КонецПроцедуры // ПриЗаписи
