#!/bin/bash
set -euxo pipefail

sourcery --sources Tests/PublicHolidaysTests --templates .sourcery/LinuxMain.stencil --output Tests/LinuxMain.swift

swift-format format --recursive --in-place Sources Tests Package.swift
swift-format lint --recursive Sources Tests Package.swift
