# redis-demo-deployment
This is an example deployment of Redis to AWS using a Kubernetes cluster.

Obviously, an entire K8S cluster for a single Redis instance is absurd, but I'm using this as a demonstration of how I might build a larger infrastructue footprint. 

These clusters were built with [kops](https://github.com/kubernetes/kops).  For production use, I would use a configuration management tool like Ansible or Terraform, where I could check configuration into a repository and manage it with proper organizational controls.

# Components of this environment
* [Redis](https://github.com/antirez/redis/) - The in-memory database.  I'm running the vanilla version from Docker Hub, which is built using the [community-maintained Dockerfiles](https://github.com/docker-library/redis).
* [spiped](https://github.com/Tarsnap/spiped) - A simple authenticating, encrypted TCP proxy.  Used to proxy the Redis replication streams because [Redis does not support TLS](https://github.com/antirez/redis/issues/2178) :(
* [Kubernetes](https://kubernetes.io/) - v1.8.4 - The orchestration framework of choice.  Spins up our applications as needed, reallocates resources as servers come off- and on-line, provisions storage, etc.  
* [CoreOS Container Linux](https://coreos.com/os/docs/latest/) - The Linux distribution which runs on all Kubernetes servers.   Based on ChromeOS, I chose CoreOS because it offers a best-of-breed, curated installation of [Docker](https://www.docker.com/).  It also provides automatic software updates and is able to coordinate with Kubernetes to shift application loads around the cluster while individual cluster servers are updated and rebooted.
* [Docker](https://www.docker.com/) - Packaging for the Redis and spiped applications.  Chosen because it provides a concise way to describe application distribution and execution from a human-readable text file.  Also provides convenient packaging and quick distribution of software updates.

# Key files in this repo
* [kube/deployment.yaml](https://github.com/chrissnell/redis-demo-deployment/blob/master/kube/deployment.yaml) - The Kubernetes **Deployment** object, which describes what containers comprise the smallest complete unit (called a "**Pod**")of this application and specifies how many replicas of these units are needed.  It also specifies the Docker image(s) from which to run the app, along with network ports on which the application listens, any data volumes needed, and any per-deployment configuration data.
* [kube/persistentvolumeclaim.yaml](https://github.com/chrissnell/redis-demo-deployment/blob/master/kube/persistentvolumeclaim.yaml) - The Kubernetes **PersistentVolumeClaim** object, which desribes any persistent storage that is needed by the Pods.
* [kube/secret.yaml](https://github.com/chrissnell/redis-demo-deployment/blob/master/kube/secret.yaml) - The Kubernetes **Secret** object, which contains base64-encoded copies of any secrets that might need to be provided to the application at runtime.  Also occasionally used to provide configuration data.  I'm using it to provide the encryption key to spiped.
