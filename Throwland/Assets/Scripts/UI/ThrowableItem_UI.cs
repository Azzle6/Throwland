using Resources;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ThrowableItem_UI : MonoBehaviour
{
    [SerializeField] Image Icon;
    [SerializeField] Ressource_UI[] Ressources_UI;

    void UpdateView(ThrowableItemData item)
    {
        Icon.sprite = item.sprite;
        if (item.woodQty > 0)
            Ressources_UI[0].UpdateView(new ResourceQuantity(E_ResourceType.WOOD,item.woodQty));
        else
            Ressources_UI[0].gameObject.SetActive(false);

        if (item.crystalQty > 0)
            Ressources_UI[1].UpdateView(new ResourceQuantity(E_ResourceType.CRYSTAL, item.woodQty));
        else
            Ressources_UI[1].gameObject.SetActive(false);
    }
}

[System.Serializable]
public struct ThrowableItemData
{
    public string name;
    public Sprite sprite;

    public int woodQty, crystalQty;

}
