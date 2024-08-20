using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameplayUI : MonoBehaviour
{
    public bool snapToFollower = false;
    public IGameplayInterfacable GameplayInterfacable;
    public virtual void Initialize(IGameplayInterfacable gi, Object context = null)
    {
        this.GameplayInterfacable = gi;
        if (snapToFollower) GetComponent<ScreenspaceFollowerUI>().SetTarget((gi as MonoBehaviour).transform);
    }

    public virtual void OnUnregister()
    {

    }
}
