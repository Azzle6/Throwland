using System;
using System.Collections.Generic;
using Items;

namespace Resources
{
    public class ResourcesManager
    {
        public Dictionary<E_ItemOwner, ResourcesStocks> ResourcesStocks;
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