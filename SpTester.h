// $Id$ 

class SpTester
{
	public:
		static void checkEqual(string testName, string a, string b);
		static void checkEqual(string testName, bool a, bool b);
		static void checkEqual(string testName, int a, int b);
		static void checkEqual(string testName, float a, float b);
		static void check(string testName, bool a);
		static void finish();
		static void setVerbose(bool v) { verbose = v; };
		static void setFloatDelta(float d) { floatDelta = d; };
		static float getFloatDelta() { return floatDelta; };
	private:
		static bool verbose;
		static int noErrors;
		static float floatDelta;
};

