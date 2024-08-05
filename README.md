### Deploy Angular App to OCP

This is illustration of deploying AngularJS app to OCP, the code is taken from Red Hat Dev: https://github.com/redhat-developer-demos/Angular-openshift-example
The change that is made to this repo is the base image in the Containerfile is using the OCP internal image: image-registry.openshift-image-registry.svc:5000/openshift/nodejs:16-ubi8 and also using version 16, which you can change based on your application requirements.

### Steps:

To deploy the code to OCP you need a base image where you can invoke the angular installation and add your files to it.

You can use either S2I or Tekton pipeline for that.

#### Deploy using S2I :

From the developer console, go to "Import from Git"

<img width="390" alt="Screenshot 2024-07-08 at 11 29 24 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/fb370e06-ddbc-444a-bcca-d5fcc1bfc98a">

Fill in the source code of this repositorym click on advanced and add also the tag/branch and any context root.

<img width="698" alt="Screenshot 2024-07-08 at 11 30 55 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/7fd13d74-694d-4285-a084-eefa5cf87bc4">

Note: In case your respositiry is private, you need to have a service account or ssh key or user to be able to fetch the code.

OCP will detect the ContainerFile and will select DockerFile strategy (you can change the strategy but we need the DockerFile strategy for AngularJS app).

Give the app name and keep the build options as "Builds"

<img width="685" alt="Screenshot 2024-07-08 at 11 32 29 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/2c17d836-0319-4435-a6b2-60b6d6490ba1">

Click on "Create", OpenShift will handle the build and deployment of the application.

Note: If the Pod is in "Error" you can either delete it or scale to zero then 1 and it will be running successfully.

<img width="703" alt="Screenshot 2024-07-08 at 11 36 20 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/bce97a56-161b-49f6-bb4b-ca9931dc61d6">

Click on the route and check the application:

<img width="433" alt="Screenshot 2024-07-08 at 11 36 53 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/6956ceeb-fe80-4380-ab02-292865099c7b">


#### Deploy using Tekton Pipeline :

Follow the same step until you reach the Build Options, select "Pipeline" and select the pipeline as "Buildah Deployment"

<img width="687" alt="Screenshot 2024-07-08 at 11 38 51 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/d8401538-2564-4b48-9ca7-be2ea2adb74d">

Click on "Create'

As our ContainerFile name is needed for the pipeline, we need to open the pipeline and configure the name, so go to pipeline section and select our app pipeline and click on Edit from the action menu:

<img width="1199" alt="Screenshot 2024-07-08 at 11 40 34 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/10f1064b-6a28-4449-bab3-cc1a70a14e29">

Select the build stage and add the container file name "Containerfile" in the dockerfile parameter field:

<img width="1196" alt="Screenshot 2024-07-08 at 11 45 55 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/b69b63d5-5aa0-469b-b914-1672a774763f">

Click on start pipeline and keep the default, just add "main" to the Git revision and click on "Start"

Monitor the pipeline execution:

<img width="763" alt="Screenshot 2024-07-08 at 11 49 48 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/6c58d45e-0cae-4722-bc79-41948e01d163">


Click on the route and check the application:

<img width="433" alt="Screenshot 2024-07-08 at 11 36 53 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/6956ceeb-fe80-4380-ab02-292865099c7b">


#### Deploy using Builds for OpenShift :

First you need to install the Builds for OpenShift Operator:

<img width="276" alt="Screenshot 2024-07-08 at 11 54 49 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/f2f5d78d-e95a-43f6-a9bf-a5fb4a70f6df">

Once, installed create an instance of "Shipwright Build", keep the default

<img width="696" alt="Screenshot 2024-07-08 at 12 32 03 PM" src="https://github.com/osa-ora/angular-demo/assets/18471537/ea1641f3-df9d-4dfd-86bd-9c27ade1e177">

Install the Shipwright command line of the latest release from the following URL:

```
https://github.com/shipwright-io/cli/releases
```

Now, you can deploy the application by creating a Shipwright build either from the console or from the command line:

```
//create an openshift project
oc new-project dev

//create shipwright build for our application in the 'dev' project
//our project code is in the root of the Git repo, otherwise we could have used '--source-context-dir="docker-build"' flag to specify the context folder of our application.
//
shp build create angular-buildah --strategy-name="buildah" --source-url="https://github.com/osa-ora/angular-demo" --dockerfile="Containerfile"  --output-image="image-registry.openshift-image-registry.svc:5000/dev/angular-app"

//start the build and follow the output
shp build run angular-buildah --follow

//create an application from the container image
oc new-app angular-app

//expose our application
oc expose service/angular-app

//test our application is deployed ..
curl $(oc get route angular-app -o jsonpath='{.spec.host}')/

```
You can also click on the route to access the application as we did before.

You can do the same from the Dev Console

Go to "Builds" section and click on Create and select "Shipwright Build"

<img width="1189" alt="Screenshot 2024-07-08 at 12 38 53 PM" src="https://github.com/osa-ora/angular-demo/assets/18471537/9eb76e9b-1dc0-41a2-992e-ea49985ba513">

Post the following content:

```
apiVersion: shipwright.io/v1beta1
kind: Build
metadata:
  name: my-shipwright-build
  namespace: dev
spec:
  output:
    image: 'image-registry.openshift-image-registry.svc:5000/dev/angular-app'
  paramValues:
    - name: dockerfile
      value: Containerfile
  source:
    git:
      url: 'https://github.com/osa-ora/angular-demo'
      revision: main
    type: Git
  strategy:
    kind: ClusterBuildStrategy
    name: buildah
```
Note: For a private repository, you need to create a secret (that contains a username/password or ssh key) then modify the previous build to add this secret:
```
  source:
    git:
      cloneSecret: my-private-repo-token
      url: 'https://github.com/osa-ora/angular-demo'
```

Click on Create and then click on "Start Build", follow the logs:

<img width="841" alt="Screenshot 2024-07-08 at 12 43 08 PM" src="https://github.com/osa-ora/angular-demo/assets/18471537/b9003c65-5a54-47a3-a720-5730d9dee0df">

Now, you can deploy the appliation using "oc new-app angular-app" or from the console using container image option:

<img width="708" alt="Screenshot 2024-07-08 at 12 46 57 PM" src="https://github.com/osa-ora/angular-demo/assets/18471537/d2d98b2a-e741-4725-a2b3-40812c314385">

Test the application route and we are done!

#### Deploy the App with a Private Repository

You can use any of the previous ways using the private repository configuration, go to the Containerfile and uncomment the private repository line:

```
# Configure this in case you need to build from a private repository, just change the url to ur registry url
RUN npm config set registry {your repository URL here}
```


