using Helpers;
using UnityEngine;

namespace Prefabs.Items
{
    [CreateAssetMenu(menuName = "Custom/AssetsReferencesSO", fileName = "AssetsReferencesSO")]
    public class AssetsReferencesListSO : ScriptableObject
    {
        public ItemsReferencesDictionary ItemsReferences;
    }
}
