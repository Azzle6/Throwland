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

        [ServerRpc(RequireOwnership = false)]
        public void DeleteItemServerRpc()
        {
            this.GetComponent<NetworkObject>().Despawn();
            base.OnNetworkDespawn();
        }
        
        [ServerRpc(RequireOwnership = false)]
        public void ChangePositionServerRpc(Vector3 pos)
        {
            transform.position = pos;
            ChangePositionClientRpc(pos);
        }

        [ClientRpc]
        private void ChangePositionClientRpc(Vector3 pos)
        {
            transform.position = pos;
        }
    }

    public enum E_ItemOwner
    {
        PLAYER_1,
        PLAYER_2,
        NEUTRAL
    }
}
