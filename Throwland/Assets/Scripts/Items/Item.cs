using System;
using Unity.Netcode;
using UnityEngine;

namespace Items
{
    [Serializable]
    public abstract class Item : NetworkBehaviour
    {
        public string ID => name;
        public NetworkVariable<E_ItemOwner> Owner;
        public NetworkVariable<int> HP;
        public abstract void OnHit(int damages);

        [ServerRpc(RequireOwnership = false)]
        public void DeleteItemServerRpc()
        {
            this.GetComponent<NetworkObject>().Despawn();
            base.OnNetworkDespawn();
        }

        [ServerRpc(RequireOwnership = false)]
        public void SetOwnerServerRpc(E_ItemOwner owner)
        {
            Owner.Value = owner;
        }
        
        //[ServerRpc(RequireOwnership = false)]
        //public void ChangePositionServerRpc(Vector3 pos)
        //{
        //    transform.position = pos;
        //    ChangePositionClientRpc(pos);
        //}

        //[ClientRpc]
        //private void ChangePositionClientRpc(Vector3 pos)
        //{
        //    transform.position = pos;
        //}

        [ServerRpc]
        public void ChangeHpServerRpc(int newHp)
        {
            this.HP.Value = newHp;
        }
        
    }

    public enum E_ItemOwner
    {
        PLAYER_1,
        PLAYER_2,
        NEUTRAL
    }
}
