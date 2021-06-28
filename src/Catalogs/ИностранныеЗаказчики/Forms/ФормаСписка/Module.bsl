
&НаКлиенте
Процедура ПеренумероватьПодчиненные(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПеренумероватьПодчиненныеПродолжение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, "Перенумеровать подчиненные элементы?", РежимДиалогаВопрос.ДаНет, 60);
	
КонецПроцедуры

&НаСервере
Процедура ПеренумероватьПодчиненныеНаСервере(Родитель)
	
	Выборка = Справочники.ИностранныеЗаказчики.Выбрать(Родитель);
	
	Пока Выборка.Следующий() Цикл
		
		СпрОб = Выборка.ПолучитьОбъект();
		СпрОб.УстановитьНовыйКод();
		СпрОб.Записать();
			
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренумероватьПодчиненныеПродолжение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ТекСтрока = Элементы.Список.ТекущаяСтрока;
		
		Если НЕ ТекСтрока.Пустая() Тогда
			ПеренумероватьПодчиненныеНаСервере(Элементы.Список.ТекущаяСтрока);
		КонецЕсли; 
		
		Элементы.Список.Обновить();
		
	КонецЕсли; 
	
КонецПроцедуры
 