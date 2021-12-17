namespace Cinerva.TestConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            var queryLibrary = new QueryLibrary();

            //EX2
            queryLibrary.GetAllPropertiesInCity("Iasi");

            //EX3
            queryLibrary.GetAllClientsWithPayedReservations();

            //EX4
            queryLibrary.GetAllAdministratorsOfPropertyTypeInCity("Guest House", "Brasov");

            //EX5
            queryLibrary.GetAllRoomTypesAndPricesForNamedHotelInCountry("InterContinental", "Romania");

            //EX6
            queryLibrary.GetTopXPropertiesInCountryByReservationCountInMonth(5, "Romania", 11, 2021);

            //EX7
            queryLibrary.GetHotelsWithPoolsAvailableToday();

            //EX9
            queryLibrary.GetHighestRatedPropertyWithFacilityAvailableNextWeekend("Spa");

            //EX10
            queryLibrary.GetMostReservedMonthForHotel(28);

            //EX11
            queryLibrary.GetPropertiesWithAvailableRoomsForNextWeekendInCityBetweenPrice(2, "Double Room", "Antwerp", 100, 150);

            //EX12
            queryLibrary.GetNumberOfGuestsWithBookingsInMonthAndCity(5, 2021, "Iasi");

        }
    }
}
