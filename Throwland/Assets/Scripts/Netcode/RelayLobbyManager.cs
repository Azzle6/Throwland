using System.Threading.Tasks;
using TMPro;
using Unity.Netcode;
using Unity.Netcode.Transports.UTP;
using Unity.Networking.Transport.Relay;
using Unity.Services.Authentication;
using Unity.Services.Core;
using Unity.Services.Relay;
using Unity.Services.Relay.Models;

namespace Netcode
{
    using UnityEngine;
    
    public class RelayLobbyManager : MonoBehaviour
    {
        [SerializeField] 
        private GameObject relayLobbyUI;
        
        [SerializeField]
        private TMP_Text joinCodeText;
        [SerializeField]
        private TMP_InputField codeInputField;
        
        private async void Start()
        {
            await UnityServices.InitializeAsync();

            await AuthenticationService.Instance.SignInAnonymouslyAsync();
        }

        public async void StartRelayHost()
        {
            await this.TryDisconnect();
            
            string joinCode = await this.StartHost();
            joinCodeText.text = joinCode;
        }

        public async void JoinRelay()
        {
            await this.TryDisconnect();
            await this.StartClient(this.codeInputField.text);
        }

        private async Task TryDisconnect()
        {
            if (NetworkManager.Singleton.IsConnectedClient)
            {
                NetworkManager.Singleton.Shutdown();
                await Task.Run(() =>
                {
                    try
                    {
                        while (NetworkManager.Singleton.ShutdownInProgress)
                        { }
                    }
                    catch
                    { }
                });
            }
        }

        private async Task<string> StartHost()
        {
            Allocation allocation = await RelayService.Instance.CreateAllocationAsync(2);
            
            NetworkManager.Singleton.GetComponent<UnityTransport>().SetRelayServerData(new RelayServerData(allocation, "dtls"));

            string joinCode = await RelayService.Instance.GetJoinCodeAsync(allocation.AllocationId);

            return NetworkManager.Singleton.StartHost() ? joinCode : null;
        }

        private async Task<bool> StartClient(string joinCode)
        {
            JoinAllocation joinAllocation = await RelayService.Instance.JoinAllocationAsync(joinCode);
            
            NetworkManager.Singleton.GetComponent<UnityTransport>().SetRelayServerData(new RelayServerData(joinAllocation, "dtls"));

            return !string.IsNullOrEmpty(joinCode) && NetworkManager.Singleton.StartClient();
        }
    }
}
