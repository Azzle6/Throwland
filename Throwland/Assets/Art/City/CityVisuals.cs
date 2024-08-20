using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class CityVisuals : MonoBehaviour
{
    public GameObject buildingVisualsPrefab;
    public Sprite[] buildingSprites;

    public float radius = 0.5f;
    public Vector2 grid;

    public float appearDelay = 0.05f;

    public Dictionary<Vector2, GameObject> slots = new Dictionary<Vector2, GameObject>();

    private int team;
    private Coroutine updateRadiusCoroutine;
    
    private void OnDrawGizmosSelected()
    {
        Vector2 pos = transform.position;
        Gizmos.DrawWireSphere(pos, radius);
        
    }

    private void Start()
    {
        UpdateRadius(this.radius);
    }

    public void SetTeamIndex(int teamIndex)
    {
        this.team = teamIndex;
        GetComponentInChildren<TeamColoredVisual>().teamIndex = teamIndex;
        if(this.updateRadiusCoroutine != null)
            StopCoroutine(this.updateRadiusCoroutine);
        updateRadiusCoroutine = StartCoroutine(this.UpdateRadiusCoroutine(this.radius));
    }

    public void UpdateRadius(float value, bool destructive = false)
    {
        if(this.updateRadiusCoroutine != null)
            StopCoroutine(this.updateRadiusCoroutine);
        
        updateRadiusCoroutine = StartCoroutine(this.UpdateRadiusCoroutine(value, destructive));
    }

    private IEnumerator UpdateRadiusCoroutine(float value, bool destructive = false)
    {
        Vector2 pos = transform.position;
        radius = value;
        Vector2Int newGrid = new Vector2Int(Mathf.RoundToInt(this.grid.x * this.radius), Mathf.RoundToInt(this.grid.y * this.radius));

        int debugCount = 0;

        if (destructive)
        {
            List<Vector2> keyToDelete = new List<Vector2>();
            
            foreach (var instance in this.slots)
            {
                if(Vector2.Distance(pos, instance.Key) > this.radius + 0.1f)
                    keyToDelete.Add(instance.Key);
            }

            foreach (var toDelete in keyToDelete)
            {
                GameObject goToDestroy = this.slots[toDelete];
                this.slots.Remove(toDelete);
                Destroy(goToDestroy);
            }

            yield break;
        }
        
        for (int x = 0; x < newGrid.x; x++)
        {
            for (int y = 0; y < newGrid.y; y++)
            {
                float evalX = (float)x / (newGrid.x - 1);
                float xPos = Mathf.Lerp(pos.x - radius, pos.x + radius, evalX) + Random.Range(-this.radius / newGrid.x, this.radius / newGrid.x);
                float evalY = (float)y / (newGrid.y - 1);
                float yPos = Mathf.Lerp(pos.y - radius, pos.y + radius, evalY) + Random.Range(-this.radius / newGrid.y, this.radius / newGrid.y);

                Vector2 point = new Vector2(xPos, yPos);
                
                if (Vector2.Distance(point, pos) > radius + 0.1f || this.slots.Any((e) => Vector2.Distance(e.Key, point) < 0.6f)) continue;

                debugCount++;

                GameObject instance = Instantiate(buildingVisualsPrefab, point, Quaternion.identity, transform);
                SpriteRenderer rend = instance.GetComponentInChildren<SpriteRenderer>();
                rend.sprite = buildingSprites[Random.Range(0, buildingSprites.Length)];
                rend.GetComponent<TeamColoredVisual>().SetTeam(team);

                slots.TryAdd(point, instance);

                yield return new WaitForSeconds(appearDelay);
            }
        }
    }

    public void Spawn()
    {

    }
}
