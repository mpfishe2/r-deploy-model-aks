# Deploying R Machine Learning Model with Plumber and Azure Kubernetes Service

## Deploying and Serving R Models to AKS with Plumber

**Model code adapted from:** https://shirinsplayground.netlify.com/2018/01/plumber/  
**Author of model**: Dr. Shirin Glander   

Azure Kubernetes Service (AKS) can be used to deploy and serve Machine Learning Models. R is a popular language for Machine Learning and using Plumber (https://www.rplumber.io/) you can construct an REST API to expose the Machine Learning model. Using Docker, the R model and the Plumber script can be containerized using Docker and served on Azure Kubernetes Service. The image is deployed through a Deployment object and exposed to the Internet thourgh a LoadBalancer object. 

## How to deploy this example 

### Pre-requisites

- Azure Subscription
- Azure Kubernetes Service Cluster
- Azure Container Registry
- Azure CLI
- `kubectl` and `helm` tools installed
- Docker

### Instructions

1. Clone this repository onto your local machine
```shell
git clone https://github.com/mpfishe2/r-deploy-model-aks.git
```
2. Make the cloned repository your working directory  
```shell
cd r-deploy-model-aks`
```
3. Pull the Docker image `mpfplumber`
```docker
docker pull mpfishe2/mpfplumber
```
4. Tag the image to prepare it for pushing to your Azure Container Registry
```shell
docker tag mpfishe2/mpfplumber:latest <name-of-acr-registry>.azurecr.io/mpfplumber:latest
```
> **Note**: If the name of the Azure Container Registry is containerland than the tag would be containerland.azurecr.io/mpfplumber:latest

5. Login in to Azure CLI
```
az login
```
6. Login in to your Azure Container Registry
```
az acr login --name <name-of-acr-registry>
```
7. Push the image that you tagged in **Step 4** to your Azure Container Registry
```
docker push <name-of-acr-registry>.azurecr.io/mpfplumber:latest
```
8. Deploy the application in Azure Kubernetes Service Cluster
#### **Helm Deployment**
```
helm install ./raksdeploy
```
#### **Non-Helm Deployment**
```
cd aksfiles
kubectl apply -f .
```
9. Get the **`<EXTERNAL-IP>`** of the LoadBalancer that is Deployed (**Note:** It might take a few minutes for the External IP to populate)
```
kubectl get svc
```
> The above command will display all the services. You are looking for the one associated with your Helm installation or one that is titled aksdemo-model-deploy

10. Test using cURL
```shell
curl "http://<EXTERNAL-IP-FROM-SERVICE>/predict?age=0.511111111111111&bp=0.111111111111111&sg_1.005=1&sg_1.010=0&sg_1.015=0&sg_1.020=0&sg_1.025=0&al_0=0&al_1=0&al_2=0&al_3=0&al_4=1&al_5=0&su_0=1&su_1=0&su_2=0&su_3=0&su_4=0&su_5=0&rbc_normal=1&rbc_abnormal=0&pc_normal=0&pc_abnormal=1&pcc_present=1&pcc_notpresent=0&ba_present=0&ba_notpresent=1&bgr=0.193877551020408&bu=0.139386189258312&sc=0.0447368421052632&sod=0.653374233128834&pot=0&hemo=0.455056179775281&pcv=0.425925925925926&wbcc=0.170454545454545&rbcc=0.225&htn_yes=1&htn_no=0&dm_yes=0&dm_no=1&cad_yes=0&cad_no=1&appet_good=0&appet_poor=1&pe_yes=1&pe_no=0&ane_yes=1&ane_no=0"
```
This should be the response:
```
----------------
Test case predicted to be ckd
----------------
```
