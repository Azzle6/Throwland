using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameplayUIManager<T> : Singleton<T> where T : Component
{
    public Transform parent;
    public GameObject prefab;
    public Canvas Canvas { get; private set; }

    public virtual void Start()
    {
        Canvas = GetComponent<Canvas>();
    }

    public List<GameplayUI> uis = new List<GameplayUI>();

    public virtual GameplayUI Register(IGameplayInterfacable gi, GameObject overridePrefab = null, Object context = null)
    {
        //Debug.Log("Register " + (gi as Component).gameObject);
        GameObject usedPrefab = overridePrefab == null ? prefab : overridePrefab;
      return  SpawnPrefab(gi, usedPrefab, context);
    }

    public virtual GameplayUI SpawnPrefab(IGameplayInterfacable gi, GameObject usedPrefab, Object context = null)
    {
        //Debug.Log(gameObject.name + " " + uis.Count);
        foreach (var existingUI in uis)
        {
            if (existingUI.GameplayInterfacable == gi)
            {
                return null;
            }
        }

        Transform p = parent == null ? transform : parent;
        GameplayUI ui = Instantiate(usedPrefab, p).GetComponent<GameplayUI>();
        ui.gameObject.name = usedPrefab.name;
        ui.Initialize(gi, context);
        uis.Add(ui);
        return ui;
    }

    public virtual void Unregister(IGameplayInterfacable gi)
    {
        foreach (var ui in uis)
        {
            if (ui.GameplayInterfacable == gi)
            {
                if (ui == null) continue;
                if (ui.gameObject == null) continue;
                ui.OnUnregister();
                Destroy(ui.gameObject);
                uis.Remove(ui);
                return;
            }
        }
    }

    public GameplayUI GetUIOf(IGameplayInterfacable gi)
    {
        foreach (var ui in uis)
        {
            if (ui.GameplayInterfacable == gi) return ui;
        }

        return null;
    }
}
