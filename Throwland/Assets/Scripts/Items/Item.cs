using System;
using Unity.Netcode;
using UnityEngine;

namespace Items
{
    [Serializable]
    public abstract class Item : NetworkBehaviour
    {
        public string ID => name;
        public E_ItemOwner Owner;
        public int HP;
        public abstract void OnHit(int damages);

        public abstract void OnDebugPlace(Vector3 pos, E_ItemOwner owner);
    }

    public enum E_ItemOwner
    {
        PLAYER_1,
        PLAYER_2,
        NEUTRAL
    }
}
