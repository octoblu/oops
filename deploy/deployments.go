package deploy

import (
	"errors"
	"fmt"
	"sort"

	"github.com/mitchellh/goamz/aws"
	"github.com/mitchellh/goamz/s3"
)

type byLastModified []s3.Key

func (s byLastModified) Len() int {
	return len(s)
}
func (s byLastModified) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}
func (s byLastModified) Less(i, j int) bool {
	return s[i].LastModified < s[j].LastModified
}

func getBucket(bucketName string) (s3.Bucket, error) {
	var emptyBucket s3.Bucket

	auth, err := aws.SharedAuth()
	if err != nil {
		return emptyBucket, err
	}

	client := s3.New(auth, aws.USWest2)
	resp, err := client.ListBuckets()
	if err != nil {
		return emptyBucket, err
	}

	for _, bucket := range resp.Buckets {
		if bucket.Name == bucketName {
			return bucket, nil
		}
	}

	return emptyBucket, errors.New("Bucket not found")
}

// GetDeployments retrieves all existing deployments in an
// s3 bucket for a given application name
func GetDeployments(bucketName, applicationName string) ([]string, error) {
	var deployments []string
	bucket, err := getBucket(bucketName)
	if err != nil {
		return deployments, err
	}

	prefix := applicationName + "/"
	resp, err := bucket.List(prefix, "/", "", 1000)
	if err != nil {
		return deployments, err
	}

	fmt.Printf("resp.Contents: %d", len(resp.Contents))
	keys := resp.Contents
	sort.Sort(byLastModified(keys))

	for _, key := range keys {
		deployment := key.LastModified + "   " + key.Key
		deployments = append(deployments, deployment)
	}
	return deployments, nil
}
