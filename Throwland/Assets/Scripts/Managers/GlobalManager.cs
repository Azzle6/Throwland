using Items;
using Items.Buildings;
using Items.Throwable;
using Prefabs.Items;
using Unity.Netcode;
using UnityEngine.Serialization;

namespace Managers
{
    using UnityEngine;
    public class GlobalManager : NetworkBehaviour
    {
        public static GlobalManager Instance;
        
        public AssetsReferencesListSO AssetsReferences;
        public UIManager UIManager;
        public Transform FirstSlingerSpawn;
        public Transform SecondSlingerSpawn;
        
        public E_ItemOwner ClientTeam;

        private void Awake()
        {
            if (Instance == null)
                Instance = this;
            else
                Destroy(this);
        }

        [ServerRpc(RequireOwnership = false)]
        public void RequestThrowObjectServerRpc(string throwableID, Vector2 pos, Vector2 dir, Vector2 velocity, E_ItemOwner owner)
        {
            if (throwableID == null || !this.AssetsReferences.ItemsReferences.ContainsKey(throwableID))
            {
                Debug.LogWarning($"throwable with ID {throwableID} doesn't exists.");
                return;
            }
            
            Throwable instantiatedPrefab = Instantiate(this.AssetsReferences.ItemsReferences[throwableID]) as Throwable;
            if (instantiatedPrefab == null)
            {
                Debug.LogWarning($"item with ID {throwableID} isn't a throwable one.");
                return;
            }
            instantiatedPrefab.GetComponent<NetworkObject>().Spawn();
            instantiatedPrefab.Owner = owner;
            instantiatedPrefab.Throw(pos, dir, velocity);
        }

        [ServerRpc(RequireOwnership = false)]
        public void RequestSpawnBuildingServerRpc(string buildingID, Vector2 pos, E_ItemOwner owner)
        {
            if (buildingID == null || !this.AssetsReferences.ItemsReferences.ContainsKey(buildingID))
            {
                Debug.LogWarning($"Building with ID {buildingID} doesn't exists.");
                return;
            }
                
            
            Building instantiatedPrefab = Instantiate(this.AssetsReferences.ItemsReferences[buildingID]) as Building;
            if (instantiatedPrefab == null)
            {
                Debug.LogWarning($"Item with ID {buildingID} isn't a building.");
                return;
            }
            
            instantiatedPrefab.GetComponent<NetworkObject>().Spawn();
            instantiatedPrefab.Owner = owner;
            instantiatedPrefab.transform.position = pos;
        }
    }
}
