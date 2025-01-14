/*
 * Anshul Yadav updated code for NDI compliance
 */

#include "fileparser.hpp"
#include <fstream>
#include <cstring>

using namespace std;

FileParser::FileParser(string directory, string extension, uint32_t samplesPerSecond, bool loop) {
    this->directory = directory;
    this->extension = extension;
    this->loop = loop;

    this->sampleDuration_us = 1000 * 1000 / samplesPerSecond;
	if (!NDIlib_initialize())
	return ;

	NDIlib_recv_create_v3_t mRecvType_H264;

	mRecvType_H264.p_ndi_recv_name = "SRT-AY-RECVR-H264";
	mRecvType_H264.color_format = (NDIlib_recv_color_format_e) NDIlib_recv_color_format_ex_compressed_v5_with_audio; 
	// NDIlib_recv_color_format_ex_compressed_v3_with_audio;
	mRecvType_H264.bandwidth = NDIlib_recv_bandwidth_highest;

	NDIlib_source_t src;
	//src.p_ndi_name = "ANSHUL-PC (NVIDIA GeForce RTX 3060 1)";
	//src.p_ndi_name = "NDIPTZ2 (Chan_1, 192.168.208.50)";
	src.p_ndi_name = "ANSHUL-PC (ANSHUL-PC (OBS))";
	//src.p_ndi_name = "PTZOpticsCamera (Channel 1)";

	mRecvType_H264.source_to_connect_to = src;
	pNDI_recv = NDIlib_recv_create_v4(&mRecvType_H264);
	if (!pNDI_recv)
		return ;

	NDIlib_recv_connect(pNDI_recv, &src);
}

FileParser::~FileParser() {
	// Destroy the receiver
	NDIlib_recv_destroy(pNDI_recv);
	NDIlib_destroy();
	stop();
}

void FileParser::start() {
    sampleTime_us = std::numeric_limits<uint64_t>::max() - sampleDuration_us + 1;
    loadNextSample();
}

void FileParser::stop() {
    sample = {};
    sampleTime_us = 0;
    counter = -1;
}

void FileParser::loadNextSample() {
	bool isValidFrame = false;
	NDIlib_video_frame_v2_t video_frame;
	sample.clear();
	while (!isValidFrame)
	{
		auto retType = NDIlib_recv_capture_v3(pNDI_recv, &video_frame, nullptr, nullptr, 2000);
		switch (retType)
		{
		case NDIlib_frame_type_video:
		{
			cout <<"\n N="<< video_frame.frame_rate_N;
			NDIlib_compressed_packet_t VideoFrameCompressedPacket;
			memcpy(&VideoFrameCompressedPacket, video_frame.p_data, sizeof(NDIlib_compressed_packet_t));
			auto DataSize = VideoFrameCompressedPacket.data_size + VideoFrameCompressedPacket.extra_data_size;

			long data_size_in_bytes = sample.size();
			auto dataPtr = video_frame.p_data + VideoFrameCompressedPacket.version;

			for (int i = 0; i < video_frame.data_size_in_bytes; ++i) {
				auto index = VideoFrameCompressedPacket.version + i;
				sample.emplace_back((std::byte)video_frame.p_data[index]);
			}
			float fps = (float)((float)video_frame.frame_rate_N / (float)video_frame.frame_rate_D);
			sampleDuration_us = 1000 * 1000 / fps;

			NDIlib_recv_free_video_v2(pNDI_recv, &video_frame);
			isValidFrame = true;
		}
		break;

		default:
			break;
		}
	}
	
	sampleTime_us += sampleDuration_us;
}

rtc::binary FileParser::getSample() {
	return sample;
}

uint64_t FileParser::getSampleTime_us() {
	return sampleTime_us;
}

uint64_t FileParser::getSampleDuration_us() {
	return sampleDuration_us;
}
