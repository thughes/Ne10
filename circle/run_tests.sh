#!/bin/bash

EXIT_CODE=0

if [ "${PLATFORM}" != "linux" ]; then
  echo "Can't run tests on ${PLATFORM}"
  exit 0
fi

mkdir test_logs

pushd test_binaries

# Run tests
for i in * ; do
  if [[ ${i} == *performance ]]; then
    echo "Skipping performance test: ${i}"
    continue
  fi

  echo -n "Running test binary: ${i}... "
  if [ "${ARCH}" == "armv7" ]; then
    qemu-arm-static -L /usr/arm-linux-gnueabihf $i > ../test_logs/${i}.txt 2>&1
  else
    qemu-aarch64-static -L /usr/aarch64-linux-gnu $i > ../test_logs/${i}.txt 2>&1
  fi
  if [ $? -ne 0 ]; then
    echo "FAILED"
    EXIT_CODE=1
  else
    echo "SUCCESS"
  fi
done

popd

echo "Test output is available in the \"Artifacts\" tab"

exit ${EXIT_CODE}
