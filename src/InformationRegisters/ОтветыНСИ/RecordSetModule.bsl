//////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(Запись.Дата) Тогда
			Запись.Дата = ТекущаяДата();
		КонецЕсли; // Если Не ЗначениеЗаполнено(Запись.Дата) Тогда
		
		Если Не ЗначениеЗаполнено(Запись.Автор) Тогда
			Запись.Автор = ПараметрыСеанса.ТекущийПользователь;
		КонецЕсли; // Если Не ЗначениеЗаполнено(Запись.Автор) Тогда
	КонецЦикла; // Для Каждого Запись Из ЭтотОбъект Цикл	
КонецПроцедуры // ПередЗаписью