### Deploy Angular App to OCP

This is illustration of deploying AngularJS app to OCP, the code is taken from Red Hat Dev: https://github.com/redhat-developer-demos/Angular-openshift-example

### Steps:

To deploy the code to OCP you need a base image where you can invoke the angular installation and add your files to it.

You can use either S2I or Tekton pipeline for that.

#### Deploy using S2I :

From the developer console, go to "Import from Git"

<img width="390" alt="Screenshot 2024-07-08 at 11 29 24 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/fb370e06-ddbc-444a-bcca-d5fcc1bfc98a">

Fill in the source code of this repository.

<img width="698" alt="Screenshot 2024-07-08 at 11 30 55 AM" src="https://github.com/osa-ora/angular-demo/assets/18471537/7fd13d74-694d-4285-a084-eefa5cf87bc4">

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

