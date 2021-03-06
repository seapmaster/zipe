
////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НайтиКлюч(Структура) Экспорт 
	Результат 		= Неопределено;
	Запрос 			= Новый Запрос;
	Запрос.Текст 	= "ВЫБРАТЬ
	             	  |	КлючиАналитикиЦен.Ссылка КАК Ссылка
	             	  |ИЗ
	             	  |	Справочник.КлючиАналитикиЦен КАК КлючиАналитикиЦен
	             	  |ГДЕ
	             	  |	КлючиАналитикиЦен.Продавец = &Продавец
	             	  |	И КлючиАналитикиЦен.Покупатель = &Покупатель
	             	  |	И КлючиАналитикиЦен.Заказ = &Заказ
	             	  |	И КлючиАналитикиЦен.Тендер = &Тендер
	             	  |	И НЕ КлючиАналитикиЦен.ПометкаУдаления";
	Запрос.УстановитьПараметр("Продавец", 	Структура.Продавец);
	Запрос.УстановитьПараметр("Покупатель", Структура.Покупатель);
	Запрос.УстановитьПараметр("Заказ", 		Структура.Заказ);
	Запрос.УстановитьПараметр("Тендер", 	Структура.Тендер);
	Выборка 		= Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат 	= Выборка.Ссылка;
	КонецЕсли; // Если Выборка.Следующий() Тогда
	
	Возврат Результат;
КонецФункции // НайтиКлюч

Функция СоздатьКлюч(Структура) Экспорт 
	Результат 		= НайтиКлюч(Структура);
	Если Не Результат = Неопределено Тогда
		Возврат Результат;
	КонецЕсли; // Если Не Результат = Неопределено Тогда
	
	КлючАналитики 	= Справочники.КлючиАналитикиЦен.СоздатьЭлемент();
	КлючАналитики.УстановитьНовыйКод();
	Структура.Свойство("Продавец", 		КлючАналитики.Продавец);
	Структура.Свойство("Покупатель", 	КлючАналитики.Покупатель);
	Структура.Свойство("Заказ", 		КлючАналитики.Заказ);
	Структура.Свойство("Тендер", 		КлючАналитики.Тендер);
	КлючАналитики.Записать();
	Результат = КлючАналитики.Ссылка;
	Возврат Результат;
КонецФункции // СоздатьКлюч
