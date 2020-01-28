# Build our images and tag them (twice, once with latest, another with $SHA)
docker build -t jpdjere/multi-client:latest -t jpdjere/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jpdjere/multi-server:latest -t jpdjere/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jpdjere/multi-worker:latest -t jpdjere/multi-worker:$SHA -f ./worker/Dockerfile ./worker
# No need to sign-up to Docker again to push them to Docker Hub
# Push them twice, once for each image that was built
docker push jpdjere/multi-client:latest
docker push jpdjere/multi-server:latest
docker push jpdjere/multi-worker:latest
docker push jpdjere/multi-client:$SHA
docker push jpdjere/multi-server:$SHA
docker push jpdjere/multi-worker:$SHA
# Apply all configs in the k8s directory with 
# kubectl (already installed before)
kubectl apply -f k8s
# Imperatively set latest images on each deployment
kubectl set image deployments/server-deployment server=jpdjere/multi-server:$SHA
kubectl set image deployments/client-deployment client=jpdjere/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=jpdjere/multi-worker:$SHA