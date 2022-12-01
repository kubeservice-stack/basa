export const defaultAutoscale = `{
  "apiVersion": "autoscaling/v2beta1",
  "kind": "HorizontalPodAutoscaler",
  "metadata": {
    "name": "",
    "labels": {}
  },
  "spec": {
    "maxReplicas": 3,
    "minReplicas": 1,
    "scaleTargetRef": {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "name": ""
    },
    "metrics": [
      {
        "type":"Resource",
        "resource": {
          "name": "cpu",
          "targetAverageUtilization": 80
        }
      }
    ]
  }
}`;
