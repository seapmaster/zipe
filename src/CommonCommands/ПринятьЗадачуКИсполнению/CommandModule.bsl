
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Задачи = Новый Массив;
	Задачи.Добавить(ПараметрыВыполненияКоманды.Источник.Объект.Ссылка);
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачиКИсполнению(Задачи);
	
	ПараметрыВыполненияКоманды.Источник.Элементы.ФормаОбщаяКомандаПринятьЗадачуКИсполнению.Видимость = Ложь;
	
	УправлениеИнтерфейсом.УстановитьДоступностьРедактированияЭлементовФормы(ПараметрыВыполненияКоманды.Источник, Истина,
		ПараметрыВыполненияКоманды.Источник.ЗаблокированныеРеквизиты, "ФормаОбщаяКомандаПринятьЗадачуКИсполнению");
	
КонецПроцедуры
