# Docker Build Notes  #

## Docker Installation ##

Install docker according to your distributions instructions. Once you have docker up and running then you can build the docker image


## Building the Docker Image ##

Build and Tag the image

	[mjackson@neon:DREAM3DSuperbuild]% docker build --tag dream3d:dream3d docker

Run the Image

	[mjackson@neon:DREAM3DSuperbuild]% docker run -it --rm dream3d:dream3d

## Uploading Container to Docker.com ##

Login to docker.com

	docker login --username=XXXXX

Be sure to use the following command to tag the final image:

	docker tag XXXXXXXXXXX dream3d/dream3d:dream3d

where you need to find out the exact hash of the final image. And finally push the image to the repo

	docker push dream3d/dream3d
