using System.Collections.Generic;

namespace Cinerva.Data
{
    public class Country
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public IList<City> Cities { get; set; }
    }
}
