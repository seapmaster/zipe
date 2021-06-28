
Процедура УдалениеСлужебнойИнформацииПриУдаленииОбъектаПередУдалением(Источник, Отказ) Экспорт
	
	//Удаление служебной информации
	
	//Удаление лога импорта объекта
	НЗ = РегистрыСведений.ЛогЗагрузки.СоздатьНаборЗаписей();
	НЗ.Отбор.Объект1С.Установить(Источник.Ссылка); 
	НЗ.Записать(Истина);
	
	//Удаление истории изменения объекта
	НЗ = РегистрыСведений.ИсторияИзмененияРеквизитовОбъектов.СоздатьНаборЗаписей();
	НЗ.Отбор.Объект.Установить(Источник.Ссылка); 
	НЗ.Записать(Истина);
	
	НЗ = РегистрыСведений.ИсторияИзмененияРеквизитовТабличныхЧастей.СоздатьНаборЗаписей();
	НЗ.Отбор.Объект.Установить(Источник.Ссылка); 
	НЗ.Записать(Истина);
	
	
КонецПроцедуры

// <Описание функции>
Функция НайтиДубльСправочникаПоНаименованию(Ссылка, Наименование = "") Экспорт
	
	Если Наименование = "" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = Справочники[Ссылка.Метаданные().Имя].Выбрать(,, Новый Структура("Наименование", Наименование));
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ Выборка.Ссылка = Ссылка Тогда
		
			Возврат Истина;
			
		КонецЕсли; 
	
	КонецЦикла; 
	
	Возврат Ложь;

КонецФункции // НайтиДубльСправочникаПоНаименованию()
