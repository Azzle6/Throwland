using Resources;

namespace Items.Buildings
{
    public class ResourceSource : Building
    {
        public override E_BuildingType BuildingType => E_BuildingType.RESOURCE_SOURCE;
        
        public E_ResourceType ResourceType;
        public int BaseProductionQuantity;
        public override void OnHit(int damages)
        {
            throw new System.NotImplementedException();
        }
    }
}