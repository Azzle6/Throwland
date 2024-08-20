using System;
using Unity.Netcode;
using UnityEngine;

namespace Items
{
    [Serializable]
    public abstract class Item : NetworkBehaviour
    {
        public string ID => name;
        [HideInInspector]
        public NetworkVariable<E_ItemOwner> Owner;
        [HideInInspector]
        public NetworkVariable<int> HP = new NetworkVariable<int>();
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

        public override void OnNetworkSpawn()
        {
            base.OnNetworkSpawn();
            Owner.OnValueChanged += OnOwnerValueChanged;
            OnOwnerValueChanged(Owner.Value, Owner.Value);
        }

        private void OnOwnerValueChanged(E_ItemOwner previousValue, E_ItemOwner newValue)
        {
            TeamColoredVisual[] visuals = GetComponentsInChildren<TeamColoredVisual>(true);

            foreach (var visual in visuals)
            {
                visual.SetTeam((int)newValue);
            }
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
