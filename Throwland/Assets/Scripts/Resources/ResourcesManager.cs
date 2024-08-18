using System;
using System.Collections.Generic;
using Items;

namespace Resources
{
    public class ResourcesManager
    {
        public Dictionary<E_ItemOwner, ResourcesStocks> ResourcesStocks;

        public void AddResource(E_ItemOwner player, E_ResourceType resourceType, int quantity)
        {
            
        }
    }

    [Serializable]
    public struct ResourcesStocks
    {
        public Dictionary<E_ResourceType, int> Resources;
    }

    [Serializable]
    public struct ResourceQuantity
    {
        public E_ResourceType ResourceType;
        public int Quantity;
    }

    public enum E_ResourceType
    {
        CRYSTAL,
        WOOD
    }
}