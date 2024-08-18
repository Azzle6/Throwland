using System.Collections.Generic;
using Items;
using Items.Buildings;
using Items.Throwable;
using Prefabs.Items;
using Unity.Netcode;

namespace Managers
{
    using UnityEngine;
    public class GlobalManager : NetworkBehaviour
    {
        public static GlobalManager Instance;
        public AssetsReferencesListSO AssetsReferences;
        public UIManager UIManager;

        public Dictionary<E_ItemOwner, NetworkClient> OwnerToClient;

        private void Awake()
        {
            if (Instance == null)
                Instance = this;
            else
                Destroy(this);
        }

        [ServerRpc(RequireOwnership = false)]
        public void RequestThrowObjectServerRpc(string throwableID, Vector2 pos, Vector2 dir, float strength, E_ItemOwner owner)
        {
            Throwable instantiatedPrefab = (Throwable)Instantiate(this.AssetsReferences.ItemsReferences[throwableID]);
            instantiatedPrefab.GetComponent<NetworkObject>().Spawn();
            instantiatedPrefab.Owner = owner;
            instantiatedPrefab.Throw(pos, dir, strength);
        }

        [ServerRpc(RequireOwnership = false)]
        public void RequestSpawnBuildingServerRpc(string buildingID, Vector2 pos, E_ItemOwner owner)
        {
            Building instantiatedPrefab = (Building)Instantiate(this.AssetsReferences.ItemsReferences[buildingID]);
            instantiatedPrefab.GetComponent<NetworkObject>().Spawn();
            instantiatedPrefab.Owner = owner;
            instantiatedPrefab.transform.position = pos;
        }
    }
}
