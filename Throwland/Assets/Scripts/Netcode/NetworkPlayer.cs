using System.Linq;
using Items;
using Managers;
using UnityEngine;

namespace Netcode
{
    using Unity.Netcode;
    
    public class NetworkPlayer : NetworkBehaviour
    {
        [HideInInspector]
        public NetworkVariable<Vector2> spawnPos = new NetworkVariable<Vector2>();
        public NetworkVariable<E_ItemOwner> playerType;
        
        public override void OnNetworkSpawn()
        {
            if (IsOwner)
            {
                this.RequestPlayerTypeServerRpc();
                this.RequestSpawnPositionServerRpc();
            }
        }

        [ServerRpc]
        void RequestPlayerTypeServerRpc()
        {
            switch (NetworkManager.ConnectedClientsList.Count)
            {
                case 1 :
                    playerType.Value = E_ItemOwner.PLAYER_1;
                    break;
                case 2 :
                    playerType.Value = E_ItemOwner.PLAYER_2;
                    break;
                default:
                    playerType.Value = E_ItemOwner.NEUTRAL;
                    break;
            }
        }

        [ServerRpc]
        void RequestSpawnPositionServerRpc()
        {
            this.spawnPos.Value = Vector2.right * NetworkManager.ConnectedClientsList.Count;
        }

        private void Update()
        {
            this.transform.position = this.spawnPos.Value;

            if (Input.GetMouseButtonDown(0) && IsOwner)
            {
                this.ThrowCity();
            }
        }

        private void ThrowCity()
        {
            GlobalManager.Instance.RequestThrowObjectServerRpc(GlobalManager.Instance.AssetsReferences.ItemsReferences["ThrowableCity"].ID, Vector2.one * Random.Range(-5f, 5f), (Vector2.one * Random.Range(-1f, 1f)).normalized, 0, this.playerType.Value);
        }
    }
}
