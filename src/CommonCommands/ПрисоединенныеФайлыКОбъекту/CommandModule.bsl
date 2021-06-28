
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла",  ПараметрКоманды);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ПараметрыВыполненияКоманды.Источник.ТолькоПросмотр);
	
	// + 20.02.2018 10:40:19 Базунов Д.А. Задача: 
	// Для БП ВзаимодействиеСРОЭ всегда открываем форму в ТолькоПросмотр
	Если ТипЗнч(ПараметрКоманды) = Тип("БизнесПроцессСсылка.ВзаимодействиеСРОЭ") Тогда
		ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	КонецЕсли; 
	// - 20.02.2018 10:40:19 Базунов Д.А. Задача:
	
	ОткрытьФорму("ОбщаяФорма.ПрисоединенныеФайлы",
	             ПараметрыФормы,
	             ПараметрыВыполненияКоманды.Источник,
	             ПараметрыВыполненияКоманды.Уникальность,
	             ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
