using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeamColoredVisual : MonoBehaviour
{
    public int teamIndex = 0;
    public virtual void Awake()
    {
        OnSetTeam();
    }

    public void SetTeam(int team)
    {
        teamIndex = team;
        OnSetTeam();
    }

    protected virtual void OnSetTeam()
    {

    }
}
