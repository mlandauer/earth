// $Id$ 

class SpTester
{
	public:
		SpTester(string className);
		static void finish();
		static void setVerbose(bool v) { verbose = v; };
		static void setFloatDelta(float d) { floatDelta = d; };
		static float getFloatDelta() { return floatDelta; };
		virtual void test() = 0;
	protected:
		void checkEqual(string testName, string a, string b);
		void checkEqual(string testName, bool a, bool b);
		void checkEqual(string testName, int a, int b);
		void checkEqual(string testName, float a, float b);
		void check(string testName, bool a);
	private:
		static bool verbose;
		static int noErrors;
		static float floatDelta;
		string name;
};

